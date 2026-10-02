class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.14"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.14/candle-0.11.14-darwin-arm64.tar.gz"
      sha256 "07b042b0fbb005498695ee77f10730dc81ebb00b629256e43451483ef3b98f46"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.14/candle-0.11.14-darwin-x64.tar.gz"
      sha256 "143a807b85d251f704295338fb80990ca5a85744e95998cda7d72814394a9b3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.14/candle-0.11.14-linux-arm64.tar.gz"
      sha256 "41eb58d3be09d9eafbf9df48037d215fac4b36efae9862d6f98ea365da82fae7"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.14/candle-0.11.14-linux-x64.tar.gz"
      sha256 "273b638e5e4cb5c971b9eb2b59070a10ef44349c811acedb0047cae8342a16ec"
    end
  end

  def install
    bin.install "candle"
    # Beside candle in the Cellar, which is where the CLI looks after resolving its own real path.
    bin.install "candle-fido2"
    # The signed Secure Enclave helper (Ember Phase 2 PR F) is in the darwin tarballs only when the
    # release's policy said "signed"; the CLI looks for it in libexec beside bin.
    libexec.install "candle-enclave.app" if File.exist?("candle-enclave.app")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
    assert_match version.to_s, shell_output("#{bin}/candle-fido2 --version")
  end
end

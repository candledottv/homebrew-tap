class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.40"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.40/candle-0.11.40-darwin-arm64.tar.gz"
      sha256 "d95c7401721db11ff1d6bd2a17dc972ee9858869aa7b9d05c6670914b263dff0"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.40/candle-0.11.40-darwin-x64.tar.gz"
      sha256 "dae7a1250b6f9a3d7acd8faa070aafa211177f4776095219cb9c76d4b5d6a837"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.40/candle-0.11.40-linux-arm64.tar.gz"
      sha256 "ac3279a626848fb65d1584d052cbd30452b01282354a9b190518858f403ca614"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.40/candle-0.11.40-linux-x64.tar.gz"
      sha256 "94747c3cc864239cfc59752234eeefeb9a1762a5d0cfbeeabffc772f3b8ced77"
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

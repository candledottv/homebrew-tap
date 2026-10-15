class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.27"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.27/candle-0.11.27-darwin-arm64.tar.gz"
      sha256 "06fb56847c15fcc209161a23fb6df38b27cc4d6d4dd89889db7b8cce84dd0731"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.27/candle-0.11.27-darwin-x64.tar.gz"
      sha256 "7760a787161a417bc952de1756e571b0eae00226e863d90dc6e6b6a72db0fbde"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.27/candle-0.11.27-linux-arm64.tar.gz"
      sha256 "66068b4ab5a5ecfa6063844b2fceebc73c4038fd4cf847978189df78d33fe733"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.27/candle-0.11.27-linux-x64.tar.gz"
      sha256 "435ea7d1b98cd094ea38d82a71c533e4175a71fb045e400d1b84aec1d6906d09"
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

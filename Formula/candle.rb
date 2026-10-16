class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.28"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.28/candle-0.11.28-darwin-arm64.tar.gz"
      sha256 "ae758da6cca60604ad2eea8b6a939b02f1884dfe3c091580509b3820b978e94f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.28/candle-0.11.28-darwin-x64.tar.gz"
      sha256 "b738c9d9ee9d7f138cdc74ee060a2d44818af882b956b5f6e61c1619fd2ba911"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.28/candle-0.11.28-linux-arm64.tar.gz"
      sha256 "7669ea571f70b24dd9cf4460328a3083cbd1aeee713cbb5783e2b2f78b92e2ae"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.28/candle-0.11.28-linux-x64.tar.gz"
      sha256 "88f2e9ec536568210dc39e1396ab2939ab6bba17d39615e47e0691451032bdf2"
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

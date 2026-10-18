class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.33"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.33/candle-0.11.33-darwin-arm64.tar.gz"
      sha256 "000643d584693b0b8dea4568bef6e215e7ae90826ae66ed0f621c6c60a241584"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.33/candle-0.11.33-darwin-x64.tar.gz"
      sha256 "bbc21a7d02e98c28ae3e3554b183d2458dde47b829dd2e1f1a58878e24c86b7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.33/candle-0.11.33-linux-arm64.tar.gz"
      sha256 "1b0ec6049f4851a15b2375d05607e120bc9d8bbc2b2b67c867cf41d513d3ffcc"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.33/candle-0.11.33-linux-x64.tar.gz"
      sha256 "a948cba2c0a274cb30035dfb36972c091191616cf006d2ee283d7413a11c043e"
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

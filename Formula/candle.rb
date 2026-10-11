class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.23"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.23/candle-0.11.23-darwin-arm64.tar.gz"
      sha256 "218f830d4127e2431117f72611080877bec2f518d66ceca8cc3fe1cf644db5c1"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.23/candle-0.11.23-darwin-x64.tar.gz"
      sha256 "9fbcb142712b597f19b9533bbf6cfa0dce4b2f2b5b02ce19d58d463d22ebda64"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.23/candle-0.11.23-linux-arm64.tar.gz"
      sha256 "948954946f1fd04e09b79f75fb7e0204dbae4b963671375518a15ea4b16b6062"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.23/candle-0.11.23-linux-x64.tar.gz"
      sha256 "8f8220839e89fcc67969f9cfd9b82b68f49790b462a0dfddff7968afb0e0e5a4"
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

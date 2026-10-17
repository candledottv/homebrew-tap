class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.31"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.31/candle-0.11.31-darwin-arm64.tar.gz"
      sha256 "064780b730d479c6e5f6919c1f98b9dbaaba9a41e6fccdbede5ab4f8e6f0c8f4"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.31/candle-0.11.31-darwin-x64.tar.gz"
      sha256 "2d9ee15cc7a67dd043287756f534bea67e4ae731cd5bf70e35df614e381c90a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.31/candle-0.11.31-linux-arm64.tar.gz"
      sha256 "8737289c8d7af4a082300a67f55428aa0cacd797f7a16d13ff47e236b3b69d17"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.31/candle-0.11.31-linux-x64.tar.gz"
      sha256 "7d41304dc4e915cebc16d72068b173330fb7dcb1ef9dedb2c7e62edfc219f33b"
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

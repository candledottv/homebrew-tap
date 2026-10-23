class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.37"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.37/candle-0.11.37-darwin-arm64.tar.gz"
      sha256 "ab3e0f69c4f1bd515e23260c6a03b21364c2e99a06cd87dadbed12ea77b1bd8b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.37/candle-0.11.37-darwin-x64.tar.gz"
      sha256 "3163258fdc8465dc96314fb9f92c592505c51bc0d283a40e340c47e2116bdc90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.37/candle-0.11.37-linux-arm64.tar.gz"
      sha256 "b4faf0d2d089612bf82d5770132dd87e2cf356e90b132a10493ba85b0ef0c850"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.37/candle-0.11.37-linux-x64.tar.gz"
      sha256 "7ba74b41dbbf3cea48dea4fc5a004bded451d103998a671b77961802a3f898f1"
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

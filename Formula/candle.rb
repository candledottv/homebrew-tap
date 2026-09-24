class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.8"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.8/candle-0.11.8-darwin-arm64.tar.gz"
      sha256 "953d4737500cc7cd53c41bf1685c14b78ee74477fde35f64d6d2b6658de12288"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.8/candle-0.11.8-darwin-x64.tar.gz"
      sha256 "389d3224c253b8272456051e90582fc742ff39d0b4b7e2ca5f96b0865a2d0043"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.8/candle-0.11.8-linux-arm64.tar.gz"
      sha256 "f244cf2aa5fbac7e5a6f7bff44ad61e0d20cbbe1d2b218cb382f90b7480dd13c"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.8/candle-0.11.8-linux-x64.tar.gz"
      sha256 "0af2c642409bd557784740db77b6c15633c807c3a8a7b521a2bb4d3aa6baf147"
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

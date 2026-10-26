class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.12.0"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.12.0/candle-0.12.0-darwin-arm64.tar.gz"
      sha256 "9093127572734d833b8d21fd46edf85ca785d9966358d4dd5fe0e384dd08e4ef"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.12.0/candle-0.12.0-darwin-x64.tar.gz"
      sha256 "bbc87826f028af6d12179bfafffc0f5d4b8d48c5f7153e3725cb3f81f67dfc7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.12.0/candle-0.12.0-linux-arm64.tar.gz"
      sha256 "97679657c0e6ff3d81ac4ca6c3a94a2d8c0fc1d333439a3729822803c6e37480"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.12.0/candle-0.12.0-linux-x64.tar.gz"
      sha256 "8867b3d90b19c71529b603c719526ebcd357fe8fb1f18d62833c6babbefdb151"
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

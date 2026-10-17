class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.32"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.32/candle-0.11.32-darwin-arm64.tar.gz"
      sha256 "d39dd857d108672dbc703e4007c735488b92ea371f462352f4ba5d825b459b36"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.32/candle-0.11.32-darwin-x64.tar.gz"
      sha256 "79b3d736e23a58970ffe01396e3b3742d0df9ba8c616786a4913673df7d98cbd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.32/candle-0.11.32-linux-arm64.tar.gz"
      sha256 "7e7996466fa0721f91223648be7e99800ceace0bf6086a1b288642830e24d39b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.32/candle-0.11.32-linux-x64.tar.gz"
      sha256 "23ce422f468de51b8dff5deb991bd6bb15844525060c8f5676d523248b511fe0"
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

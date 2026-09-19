class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.0"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.0/candle-0.11.0-darwin-arm64.tar.gz"
      sha256 "1b31a9a946c404ac628e58fd94d9b7c5bda68f5739849c4948a059891828660b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.0/candle-0.11.0-darwin-x64.tar.gz"
      sha256 "f4ec0c7fd9e433c8a6e477131284499560e7a01c7b5f5265e91d8a469dcdc10f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.0/candle-0.11.0-linux-arm64.tar.gz"
      sha256 "2cc1ab8839a9d137e1c1c68ebb5d0846548592656cc154435e4d18f3ed1d3637"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.0/candle-0.11.0-linux-x64.tar.gz"
      sha256 "59691334bf4e2109717d3c3e4b8ac7bd74ab5d971faeb8c76c4add5fc345efdf"
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

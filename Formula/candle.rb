class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.22"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.22/candle-0.11.22-darwin-arm64.tar.gz"
      sha256 "0c86a690d20d98fe256717b60d3bdf80a15d3e7ad2651da339e775019ca15c3d"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.22/candle-0.11.22-darwin-x64.tar.gz"
      sha256 "5f04451340235e08d956934c6098c082e590124753968e3feb2c1041ad38c5b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.22/candle-0.11.22-linux-arm64.tar.gz"
      sha256 "c73f9271d1b0bd085482b1c7127b0925698de7926c0b25cc089dcbeabb5e23c2"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.22/candle-0.11.22-linux-x64.tar.gz"
      sha256 "471230a732b592648a29377c6928c4eedb45b6a1f5a1fef976743919931e23f4"
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

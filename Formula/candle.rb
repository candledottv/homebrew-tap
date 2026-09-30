class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.12"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.12/candle-0.11.12-darwin-arm64.tar.gz"
      sha256 "3873a2708f021e92555c4c325126cebdbe2776360f8bfa90c4d09419fcfd9c60"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.12/candle-0.11.12-darwin-x64.tar.gz"
      sha256 "a7d424a73400b2124bbd722a8b7201a9f26c10e27e4dbbae3ce09637736a89e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.12/candle-0.11.12-linux-arm64.tar.gz"
      sha256 "a1bd8e62b1be3d0393da38f5cb95f10bebb10fa04a98c5b43026022511f07df6"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.12/candle-0.11.12-linux-x64.tar.gz"
      sha256 "7cfd659df40e5f0bcb3a4ee2f6793669ac12ab1225870a8f1fdfbdf58d13da5e"
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

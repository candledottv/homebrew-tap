class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.10"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.10/candle-0.11.10-darwin-arm64.tar.gz"
      sha256 "e4993c8d29ed8ccddb64d69727f68d9cb4538aff05e5abba257a9ade8e22cbbb"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.10/candle-0.11.10-darwin-x64.tar.gz"
      sha256 "e62ac8b5359600ff979b77a5799aa67d917655be27e9174b2bd5de90a3b2fc43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.10/candle-0.11.10-linux-arm64.tar.gz"
      sha256 "8555bf62baa6ea9c1fef4828798fc5b1074b1a2741cd8bf23a334a5a3d73e2d8"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.10/candle-0.11.10-linux-x64.tar.gz"
      sha256 "d52564d6083a295f6d3a978e89c218d5e6fd6e60f4dc931256f9443a80aff2b9"
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

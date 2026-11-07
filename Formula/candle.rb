class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.16"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.16/candle-0.13.16-darwin-arm64.tar.gz"
      sha256 "b31c2f55456e4aa2d4ee7c34c078babc03bcc445b25b8f7ee6fabc212720cc25"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.16/candle-0.13.16-darwin-x64.tar.gz"
      sha256 "e38e290fe6608a3443064e799ad8dcc51d481cded5beb22aad179a2ac99d592b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.16/candle-0.13.16-linux-arm64.tar.gz"
      sha256 "0d8f43000578e1390662bf23ecc4cef2db9bca7ee4e9bd764e9f856bb589e36a"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.16/candle-0.13.16-linux-x64.tar.gz"
      sha256 "1bf18ca34565d16e2ea6efc65e521131abf32d99106e7300a30168aa30d4eb75"
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

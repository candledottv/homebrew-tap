class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.19"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.19/candle-0.11.19-darwin-arm64.tar.gz"
      sha256 "bdbd433967f1b52d03bc9c5961271162be10c4f17a15e80fc302d25e588a52e8"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.19/candle-0.11.19-darwin-x64.tar.gz"
      sha256 "d722dd239278259bc41dba79d08706ab0841ba9b6804e6486ae8cf41f279e7cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.19/candle-0.11.19-linux-arm64.tar.gz"
      sha256 "204a65dfb0ac439176488a90dd4efc74ff788ddc4340603a2dbcd37d041d947d"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.19/candle-0.11.19-linux-x64.tar.gz"
      sha256 "5d90501d7fb2391ad92e6409595e4318c80d82e7a73b21ff6c62f7033a770679"
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

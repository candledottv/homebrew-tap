class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.39"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.39/candle-0.11.39-darwin-arm64.tar.gz"
      sha256 "26c0486e0d1e1368b918514f48f7b6c78edf85aa0e41f727565c27b7bc6dda87"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.39/candle-0.11.39-darwin-x64.tar.gz"
      sha256 "77bacd43fb175927025e9c18507bd6378d652d1406d2bc64c0c5954239d86f6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.39/candle-0.11.39-linux-arm64.tar.gz"
      sha256 "645e1b7498089a20477854b7e48b8e6e6ebaff32403ad4669c34f674dbb862be"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.39/candle-0.11.39-linux-x64.tar.gz"
      sha256 "518366374a7ad109f3254dc5979b3176cc04ca95ca9c2e567e3ed9d16c736188"
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

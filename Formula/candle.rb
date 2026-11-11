class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.21"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.21/candle-0.13.21-darwin-arm64.tar.gz"
      sha256 "1e7ede0aec411f2dc1091d33e1dfebf071bd833fe0be45329a78c600eddc646a"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.21/candle-0.13.21-darwin-x64.tar.gz"
      sha256 "9cf882444a81dcc55a3feb8e64cdc3e6b9316d361c4a900d578a695bc7414eac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.21/candle-0.13.21-linux-arm64.tar.gz"
      sha256 "2bbee05c12dad61fbcc9963687275ca7d09820fd3ced3805533c65707e1eb689"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.21/candle-0.13.21-linux-x64.tar.gz"
      sha256 "c7388801de7f30e3fec36f8af37a1167469cb9892fff930e312159c1426027d7"
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

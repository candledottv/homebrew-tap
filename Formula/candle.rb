class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.49"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.49/candle-0.13.49-darwin-arm64.tar.gz"
      sha256 "880eb6debffd3a06f9fd1a3852a718d8923a0a4936decc792f7763c9ca5bdd7d"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.49/candle-0.13.49-darwin-x64.tar.gz"
      sha256 "45919f9ef47fe14a70f9a8e082c8ca5b3a2277d50490b6a9f93f3256b8406f1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.49/candle-0.13.49-linux-arm64.tar.gz"
      sha256 "49c24d10f5a3dfca06d87df3f05e1aff3e74ac6e2b70640f9e88862179022300"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.49/candle-0.13.49-linux-x64.tar.gz"
      sha256 "16c51a1d6b2b40ff0d49909d6cbbf0c2b8f2c6f505ceb1e20d3dc2db39564f99"
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

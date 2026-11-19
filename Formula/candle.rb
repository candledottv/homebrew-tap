class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.32"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.32/candle-0.13.32-darwin-arm64.tar.gz"
      sha256 "d4974eb29c86583ca5426d83c65751541c87a4752e288bdf0f178f11c9f7ed95"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.32/candle-0.13.32-darwin-x64.tar.gz"
      sha256 "50c47c6fa12e434841c6475c416fa4bc41f9f2b6203a32eee9c26c3df4069c98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.32/candle-0.13.32-linux-arm64.tar.gz"
      sha256 "b9825abaf06194a05b96618915013fef08799bdde475c003eb0c125ccc402484"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.32/candle-0.13.32-linux-x64.tar.gz"
      sha256 "f7bf9338598007469e5e7a920bbf9d38d009b281dc66c4cce39025d2d4905195"
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

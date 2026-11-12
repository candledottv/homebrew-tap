class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.24"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.24/candle-0.13.24-darwin-arm64.tar.gz"
      sha256 "b4ce09393f5bdeadc51b84a4a6e8d2e1a2a469d9487c54980980ff03a4573a6d"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.24/candle-0.13.24-darwin-x64.tar.gz"
      sha256 "699f9a14f049d42eea8e4a65e5d903088c7201de5a076014a628a6a17b5dd89a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.24/candle-0.13.24-linux-arm64.tar.gz"
      sha256 "19aa090e0fe494320b4a21971c24ea533f753b56d1a9dcb46c429bce1ba9fe20"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.24/candle-0.13.24-linux-x64.tar.gz"
      sha256 "208dd154498ce43d71005e1983e64c584b35667e7dd9d752108056c0cd47727e"
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

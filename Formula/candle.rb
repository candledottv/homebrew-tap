class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.17"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.17/candle-0.13.17-darwin-arm64.tar.gz"
      sha256 "c9d7b5a798f2cce4377d5fba436e23c4c5aa2e87a20b76fda29ae34eb7d2f0b1"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.17/candle-0.13.17-darwin-x64.tar.gz"
      sha256 "b74afe7f9f62c08b1f6832490669603c903f3b9598fd98c0cff8c48a244c0869"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.17/candle-0.13.17-linux-arm64.tar.gz"
      sha256 "149959d39b2d33060adcea2b20c9f96ccf7118ea53cbc2911ba034aff6e6080d"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.17/candle-0.13.17-linux-x64.tar.gz"
      sha256 "e7ed2d2a69dc42964eb0045a16f773f88bea2241e86d6d07e23e4dca9b764e3b"
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

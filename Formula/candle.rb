class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.5"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.5/candle-0.13.5-darwin-arm64.tar.gz"
      sha256 "c760da909a690003238616282b1e76cbbda57a947ccdc650b1eb9fa25f1d95eb"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.5/candle-0.13.5-darwin-x64.tar.gz"
      sha256 "0581e37e2ec29ba6adc15e3c2fec9cfc6f10c88a6817d137b94a377e081c9c19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.5/candle-0.13.5-linux-arm64.tar.gz"
      sha256 "a96e8754323c09fc26d2236284dd32eaf832d083d2fa3663784ce0d98178aff5"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.5/candle-0.13.5-linux-x64.tar.gz"
      sha256 "256ef7db01db699a9b40eba8b0758e87b90863596c00294b3d5b97dbf9f029e3"
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

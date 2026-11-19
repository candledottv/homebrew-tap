class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.33"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.33/candle-0.13.33-darwin-arm64.tar.gz"
      sha256 "1e7410f74dbeba06d456b60bf9eec74a5eef7f72ff830731dc548a9cad7ec07c"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.33/candle-0.13.33-darwin-x64.tar.gz"
      sha256 "d35309df7937ad7f59a6a1e94075f94e1935c875fba9db1d378f8a27d17e5686"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.33/candle-0.13.33-linux-arm64.tar.gz"
      sha256 "f717e22e8e106783e930ded32116e712afbdb34b05022c2440d016622d2859e7"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.33/candle-0.13.33-linux-x64.tar.gz"
      sha256 "786ee3409d2c5ec94ab3551980f36efd30453cfc1f09b7973d47db12bfb6610f"
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

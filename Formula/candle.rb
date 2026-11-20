class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.35"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.35/candle-0.13.35-darwin-arm64.tar.gz"
      sha256 "c65039894a1aa10d850c5d33eadc48ea959839019a3e419d0624e57164acabaa"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.35/candle-0.13.35-darwin-x64.tar.gz"
      sha256 "7fd5f6f46dd2a41835202bef44588c37b929e9cf2cc38fc1652ca574250223cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.35/candle-0.13.35-linux-arm64.tar.gz"
      sha256 "00f497749c47db5b82b6fc338f496e59a4ae1c320019866ab48b17da1916cf99"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.35/candle-0.13.35-linux-x64.tar.gz"
      sha256 "d82128fd3044904823ba2ba614b32d55bf2d5a355cca2e5f94862cc0f23e0568"
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

class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.11"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.11/candle-0.13.11-darwin-arm64.tar.gz"
      sha256 "60f13728c1828051f5d3009135806366439cff1eda0b1593c32b1548e930ea89"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.11/candle-0.13.11-darwin-x64.tar.gz"
      sha256 "20e84a13250edd7a3a05abf576af8a7003f1354aaf5e71eb062b374b042d45b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.11/candle-0.13.11-linux-arm64.tar.gz"
      sha256 "6f75e0b85bc9602f2d756ccdc074c17cd40c441c6f15d9a63f4c498e3c60343e"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.11/candle-0.13.11-linux-x64.tar.gz"
      sha256 "64b2c1c915ef133a3266e18e22d9a785bb93ba9e884cf22eff5d4fa8cec5d9a0"
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

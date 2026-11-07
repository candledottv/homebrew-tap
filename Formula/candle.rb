class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.18"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.18/candle-0.13.18-darwin-arm64.tar.gz"
      sha256 "9e56d0fda55f23e3b3acabee7f2b10b270ee12de6fc17337fa94d64a219453b9"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.18/candle-0.13.18-darwin-x64.tar.gz"
      sha256 "d9a50b8aa983b6d7b7b1e2aaf2baba82dd592acf199f4a6bb70d6ca620faa269"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.18/candle-0.13.18-linux-arm64.tar.gz"
      sha256 "4eb2f1efa89f479272633866a6672365cbe62e0760bc0424e4e2d7c8ae273fd0"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.18/candle-0.13.18-linux-x64.tar.gz"
      sha256 "b36d3fdfcda047514421858bf31750c5eaedac50e261f10ebc1de071629a3e4e"
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

class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.20"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.20/candle-0.13.20-darwin-arm64.tar.gz"
      sha256 "bddc7c919bae452bc5529d9dfb8e85e7963dd09c02a67663c9e49aaeede30f62"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.20/candle-0.13.20-darwin-x64.tar.gz"
      sha256 "a70058e4078a627ba40c8ab9cd66b9e7b275df421aab8dca4cd4c0803b0b4a23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.20/candle-0.13.20-linux-arm64.tar.gz"
      sha256 "a5e212296a68f82cfa7aef621ccf63f4897daa9ce57e2feb8c49198a1453e3c3"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.20/candle-0.13.20-linux-x64.tar.gz"
      sha256 "5257a8951320c2e46d736651342b5181620c933e79e0fb24cbff305a3558df16"
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

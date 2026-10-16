class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.30"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.30/candle-0.11.30-darwin-arm64.tar.gz"
      sha256 "74db574a40f2470aaf20a272604d00b2eeff7ecec1a5340efd49fa1545dc13ed"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.30/candle-0.11.30-darwin-x64.tar.gz"
      sha256 "3a8ca6356c13873a6c33c2dbbeaa7b98c70b79b062d9f629832689580166d5a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.30/candle-0.11.30-linux-arm64.tar.gz"
      sha256 "e8fc1b2796e23358909366bfed9e65645a347aa6a6e3461463b45e52d2a5700c"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.30/candle-0.11.30-linux-x64.tar.gz"
      sha256 "886a8afeb96a5c29d86c034bb0dbc7c82c5c946bb6b73d1c7a049fc564ce8719"
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

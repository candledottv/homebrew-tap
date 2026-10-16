class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.29"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.29/candle-0.11.29-darwin-arm64.tar.gz"
      sha256 "b0fbcc376198313db5c93bb03eae051a68872bc0218f5b267495fe065ca6ec5c"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.29/candle-0.11.29-darwin-x64.tar.gz"
      sha256 "0e5cbbafaeaae424950e33f83703aa2a7b7523c413a5de8df71ec70435592ec8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.29/candle-0.11.29-linux-arm64.tar.gz"
      sha256 "b97e36ca6d64d27e562303ff1e9c90a07d0c14e3f91382a8fba34f4d547da143"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.29/candle-0.11.29-linux-x64.tar.gz"
      sha256 "89ec55bef0c9be72d2329ce92bb0a7a0f93b248e507a2dd5ca40f78606c25768"
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

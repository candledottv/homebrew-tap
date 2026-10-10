class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.21"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.21/candle-0.11.21-darwin-arm64.tar.gz"
      sha256 "8379c79ff64afb84e6da69d88c18ee564fceaf50c578d49f2676f9be9aee363a"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.21/candle-0.11.21-darwin-x64.tar.gz"
      sha256 "cb70a27e69ed9a08f4aaf21b8bf0ac08a2666d0502d3df8ef45c4d533bbbf414"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.21/candle-0.11.21-linux-arm64.tar.gz"
      sha256 "b61a36818f64db85bbcec96291667c520f5ff8ef3ebd8918cdf8b86fafc46f4f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.21/candle-0.11.21-linux-x64.tar.gz"
      sha256 "fdd24e688ddcb0ce16910c92bf4c686745afc129b5eeeebb33da345e299b5c06"
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

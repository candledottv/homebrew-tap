class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.35"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.35/candle-0.11.35-darwin-arm64.tar.gz"
      sha256 "cea1333d0587b6bc2fc48941a379e1d36573fe6002e2aae2f70fb6d7e0aad24e"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.35/candle-0.11.35-darwin-x64.tar.gz"
      sha256 "b5870f785ff00d5c8ae31f36529ed5de082b50ce889b5602f347dd6f5a6e537c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.35/candle-0.11.35-linux-arm64.tar.gz"
      sha256 "b47190ff71f3d0889e2f6655e814d35c43e98ce86f11d047656bb303f3427ab2"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.35/candle-0.11.35-linux-x64.tar.gz"
      sha256 "12ed8e052c3ce624e9648e3cc11dcd2b230bcd8bb5ad088913dd541f976ec737"
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

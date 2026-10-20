class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.34"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.34/candle-0.11.34-darwin-arm64.tar.gz"
      sha256 "e15c96edfd1c6f93e26891313f9e65a9ea1b62aea61d1ad1faad2e9573edd17b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.34/candle-0.11.34-darwin-x64.tar.gz"
      sha256 "4cee7a8f55fccd4578767c47c7c6d5700db8bd6fdad75e426a5fd25dcba6216f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.34/candle-0.11.34-linux-arm64.tar.gz"
      sha256 "9fedd42e923c2f773753b289622c0ccde439883a80263f82e5a7823e9ead2483"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.34/candle-0.11.34-linux-x64.tar.gz"
      sha256 "cda2702e5ca757293276f3415fcc112be01d6ecdb62111ab4284abe14eec00e9"
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

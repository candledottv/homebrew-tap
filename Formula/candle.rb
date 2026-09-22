class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.4"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.4/candle-0.11.4-darwin-arm64.tar.gz"
      sha256 "7092f0e0f8347b05c85dbe5451bbbdcbb41e9b60c0dc98a45f8b49c872e96207"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.4/candle-0.11.4-darwin-x64.tar.gz"
      sha256 "7054b36b272f88ce54e734a124b801423786459b57011c0827fa7e17724d8409"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.4/candle-0.11.4-linux-arm64.tar.gz"
      sha256 "7c1471b15f172056d28d8daf1ab0c30826e20c2675912c317d4b164970609fc2"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.4/candle-0.11.4-linux-x64.tar.gz"
      sha256 "60bf4fb4682a1dce7f7849fc27e2833120c4f96684a8ea58999b5d809458fa83"
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

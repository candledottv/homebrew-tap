class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.9"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.9/candle-0.11.9-darwin-arm64.tar.gz"
      sha256 "b29d16f09611dccd54bdbc9fa1d40285954d5312398ea61d869b9a7bb04c0714"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.9/candle-0.11.9-darwin-x64.tar.gz"
      sha256 "11c68c9c8fc3255d9a5b8c511ef012a02b031dfc274473a810bfa9cb6727b408"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.9/candle-0.11.9-linux-arm64.tar.gz"
      sha256 "e3e377c4d1bf61bb583f1638d95f1e7b3f43df1708e441c4ae4596e41d78f602"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.9/candle-0.11.9-linux-x64.tar.gz"
      sha256 "6c6860a4408deec9f6f40d5a68605b014dd868fa496a050d66ce4d83382c607c"
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

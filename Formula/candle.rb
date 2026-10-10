class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.20"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.20/candle-0.11.20-darwin-arm64.tar.gz"
      sha256 "c6c28319d7935e919b8d3738ff624541495a3d1fe5f67c2f4414afd2f910d198"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.20/candle-0.11.20-darwin-x64.tar.gz"
      sha256 "ecbf303c424084e0f3c084e425b5a509014483308d03674da0f8001b6aa22cd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.20/candle-0.11.20-linux-arm64.tar.gz"
      sha256 "1fd6615a5d3f8b00a7540a3368d63b5354c732379e9acc3ee8df50269ed8c1a0"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.20/candle-0.11.20-linux-x64.tar.gz"
      sha256 "eeba31f0f0a4a29eae92700d52aee349b6d9c4affadf6e5fe1e41d29bafb07c8"
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

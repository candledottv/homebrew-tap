class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.24"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.24/candle-0.11.24-darwin-arm64.tar.gz"
      sha256 "25c3044dc6b866b42fee9eeb06c84ed8a2acbf9d47d0dcff7a5b0245f9a13b81"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.24/candle-0.11.24-darwin-x64.tar.gz"
      sha256 "27597fa872e31e6e331ca83990ae756fc6bf32c6e8b6b4b02936c759e180bf6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.24/candle-0.11.24-linux-arm64.tar.gz"
      sha256 "8c2c762992df600a5db49e4f357ab0591e66e6c4604744de846596bc344f7e12"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.24/candle-0.11.24-linux-x64.tar.gz"
      sha256 "221349165cf22c55c6e87b0f47212445daaaffe23950b61cfda80460f3d06427"
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

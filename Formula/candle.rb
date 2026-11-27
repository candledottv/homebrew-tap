class Candle < Formula
  desc "Candle CLI: wallets, API keys and the MCP server from your terminal"
  homepage "https://candle.tv"
  version "0.13.51"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.51/candle-0.13.51-darwin-arm64.tar.gz"
      sha256 "151d742d1f166c6caa4c01ba74ec739c09cf3f71eabffdb372dd717f8ec5dc44"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.51/candle-0.13.51-darwin-x64.tar.gz"
      sha256 "b760b30513c86138c6c2c813f7afeb17fb69686f58c54b853bb8e8f2266d8abd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.51/candle-0.13.51-linux-arm64.tar.gz"
      sha256 "48df2659cc12dc6bf95db8c5f1897718d0d1fa3d6c59c50275f7c5e5de0f25a9"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.51/candle-0.13.51-linux-x64.tar.gz"
      sha256 "d6498ae36d5575432e10db02041d06defe5ceb15bc518657b8751a57488baab8"
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

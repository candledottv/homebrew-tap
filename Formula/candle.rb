class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.9"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.9/candle-0.13.9-darwin-arm64.tar.gz"
      sha256 "7c4513541ce98e217e4152cfe0835bf4407303a68bab7183ca3232838b5ae7af"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.9/candle-0.13.9-darwin-x64.tar.gz"
      sha256 "13348d6589848f5dc021789acfbab48e77db3d20cf8c4ed9300fffa4774c464a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.9/candle-0.13.9-linux-arm64.tar.gz"
      sha256 "090c9f325326d9311c19ba9e7428e561f16b95a19b0fbe0ef85c7616448ffe76"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.9/candle-0.13.9-linux-x64.tar.gz"
      sha256 "eec629a5455c9df905252ef61b108ff14b0ac8d44bbbab6bfc133acf1ac06324"
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

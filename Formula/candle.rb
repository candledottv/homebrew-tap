class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.6"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.6/candle-0.11.6-darwin-arm64.tar.gz"
      sha256 "61f77f8e5d1b4ddec11742193145feafe9ec6e92cc4b3f8ffdb063f7a9e3bfdc"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.6/candle-0.11.6-darwin-x64.tar.gz"
      sha256 "8b9df06e5b742d27a31c455f66265016d0981dd51d3fd8be6e8dd73611da992f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.6/candle-0.11.6-linux-arm64.tar.gz"
      sha256 "1a27d8b941edf4673e4c16c062dc23b076ae41e339100b6d799b57b1f847f1a0"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.6/candle-0.11.6-linux-x64.tar.gz"
      sha256 "21754dc9cfa6530f79a511f0a8f32928033e9ec978d6d7f5387e2a274cdecea5"
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

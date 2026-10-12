class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.25"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.25/candle-0.11.25-darwin-arm64.tar.gz"
      sha256 "f17bf5b7eb9f6ac33425fbe5be858ac2468e05b145c93b729098966ef1bcf884"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.25/candle-0.11.25-darwin-x64.tar.gz"
      sha256 "8778689e102c397c1282fe39b39036cbf2471b0018a43a6a7689e5b508923961"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.25/candle-0.11.25-linux-arm64.tar.gz"
      sha256 "8d662b0cc45406b66b5e022ac2c46412b495bf1e8ecc61c7e201b795a57dbca1"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.25/candle-0.11.25-linux-x64.tar.gz"
      sha256 "46c4c9e08a351e09d04151d7bbf8a3bc8c606baa71466275a2adfb114d7795cb"
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

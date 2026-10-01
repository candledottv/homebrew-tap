class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.13"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.13/candle-0.11.13-darwin-arm64.tar.gz"
      sha256 "f2a5f85d21e99a78d3c8cfdf522c3ad05943285d22e897cb2ec99d4736dfabba"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.13/candle-0.11.13-darwin-x64.tar.gz"
      sha256 "568ce03c3d9720786d56f282269ad0c1fd15c7f3edf081c79282e3715cfdc58f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.13/candle-0.11.13-linux-arm64.tar.gz"
      sha256 "90d7f8cf984017e32307b3b25262e2d023ee7ea931897870d9bbd9e64ef62d86"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.13/candle-0.11.13-linux-x64.tar.gz"
      sha256 "19ce51ac920dbea2064771167613de5df103b428587419d0f14e6cd862e372c8"
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

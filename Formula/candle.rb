class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.3"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.3/candle-0.11.3-darwin-arm64.tar.gz"
      sha256 "e3d85ab66760eba4c2d069f8d4f1243df900eab611273cdefc8f24ad11cb2c2b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.3/candle-0.11.3-darwin-x64.tar.gz"
      sha256 "8cf358d749ad38246b11fbbc90f5d6365975a02f68e1ef816a556d17533f88b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.3/candle-0.11.3-linux-arm64.tar.gz"
      sha256 "5f4cbb8480f10f71714431740eaf460ff5e193314b2435354684c42cf69bd8dc"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.3/candle-0.11.3-linux-x64.tar.gz"
      sha256 "6e5bfe294d41aa76fdd28564ca2f4691c6528444586d73aa5427abb3f88d2b9f"
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

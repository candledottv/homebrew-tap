class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.48"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.48/candle-0.13.48-darwin-arm64.tar.gz"
      sha256 "4db4d98285c8a88d2cc34a7382e3c766cd0f4fa5ce220e4c03a69be5fa678094"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.48/candle-0.13.48-darwin-x64.tar.gz"
      sha256 "a926d60c65094d62a4351e2c90f66e64c1c716c446e4dfa2a9481b144c570c73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.48/candle-0.13.48-linux-arm64.tar.gz"
      sha256 "d5e4ec74de667ed27d47389ce39c22c963c4531d57b9b0b24d40495b09f4eee7"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.48/candle-0.13.48-linux-x64.tar.gz"
      sha256 "c42b0ac0bc46cae42c5fbd4db2045b10838f4aa3325dbe7817b4290076e7014e"
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

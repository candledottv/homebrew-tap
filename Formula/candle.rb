class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.34"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.34/candle-0.13.34-darwin-arm64.tar.gz"
      sha256 "7c2bc4b6c13d71ea4a12f7c39f9404fa5b1f3a43dd2c8ea35d2f84a82e953614"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.34/candle-0.13.34-darwin-x64.tar.gz"
      sha256 "28391612ea08194ddc81883f71d95cdc7e4e83d81c414930ed38a2a9f1fdc73c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.34/candle-0.13.34-linux-arm64.tar.gz"
      sha256 "24a6286104d79cca1c8591fec65a66054c0ea5e6a44732856b276cabcbfa01e7"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.34/candle-0.13.34-linux-x64.tar.gz"
      sha256 "2582052944a6276e6dafbf20d90214916f2d96d8b8f6db23fb83197631404f8e"
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

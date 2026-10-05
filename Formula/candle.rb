class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.17"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.17/candle-0.11.17-darwin-arm64.tar.gz"
      sha256 "1080153c568ad24841e87a1e51915b5cd1802b9a927cb00356d4dec6b50e5831"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.17/candle-0.11.17-darwin-x64.tar.gz"
      sha256 "24b840868b2b6b2cd1dd22494c7b4a704e9fd6a48c63551ecbf71d79cc120ec0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.17/candle-0.11.17-linux-arm64.tar.gz"
      sha256 "d9bba7263d206b536faec1d6cdd7a71cb3b66e617a0bf9bc8191553ef4cd476c"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.17/candle-0.11.17-linux-x64.tar.gz"
      sha256 "aaa50b703066f4d8b1de51ab8ce1d76c01f8f1b6e2cbbfc049962ed562c24812"
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

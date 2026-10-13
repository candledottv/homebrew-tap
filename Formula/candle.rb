class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.26"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.26/candle-0.11.26-darwin-arm64.tar.gz"
      sha256 "2057a0854bd74b4e788ad59ad23b1de714eb008bda299550117e7b5b98788e7b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.26/candle-0.11.26-darwin-x64.tar.gz"
      sha256 "68048cd7bd1d3ccaf6b5c39698407721f48b49b45c6fbf6306040d0e7d258af1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.26/candle-0.11.26-linux-arm64.tar.gz"
      sha256 "70f7647f41d650cef4898b152cdd703db8877abf396dbf1f182ecc63304cdf6a"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.26/candle-0.11.26-linux-x64.tar.gz"
      sha256 "29d799b0001f5a521bebadb67866e839c9fd8f0a9fe683f39079b828c1017055"
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

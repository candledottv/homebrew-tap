class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.7"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.7/candle-0.11.7-darwin-arm64.tar.gz"
      sha256 "1d30f4c229ce1c905a7bd3037697b6c74908f5aa6d07c34a1833a04858540cbe"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.7/candle-0.11.7-darwin-x64.tar.gz"
      sha256 "a5909a86643bbfca982e5c2e7434df2d7e9cf160e1f10205b081b4dc4bbadee1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.7/candle-0.11.7-linux-arm64.tar.gz"
      sha256 "e3a98de5f5e808e6be5f62fbb5775a04c34ef39434e4efd5f0bb0358e9c17272"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.7/candle-0.11.7-linux-x64.tar.gz"
      sha256 "5169cc7af155933e5f88c5527c57de9ea4ada88fd721e5a23b9288acbeb60a20"
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

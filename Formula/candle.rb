class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.18"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.18/candle-0.11.18-darwin-arm64.tar.gz"
      sha256 "0f46fddc301526d9f2094c3922b7e3f9bdacecdc8f926a962f9bef9bcb1fd5df"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.18/candle-0.11.18-darwin-x64.tar.gz"
      sha256 "0802f93c1323fc7d69c3b99a50aa76fb94a542b7d9cd4fb57989cec4da0ca053"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.18/candle-0.11.18-linux-arm64.tar.gz"
      sha256 "e70f0ca5fd65516ac4fbd93f321c66064ce332cf1b84d2fb279822ebc7620ffd"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.18/candle-0.11.18-linux-x64.tar.gz"
      sha256 "6bdf7f666d5ce4ebed8d1bbc6476f13d7cd993bf47ba2249266267aaf116cf36"
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

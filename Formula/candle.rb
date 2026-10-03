class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.15"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.15/candle-0.11.15-darwin-arm64.tar.gz"
      sha256 "ba80bef3a4e9a88543d8ba0a0b457193ffd0f70b03d216579118d71000b586b8"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.15/candle-0.11.15-darwin-x64.tar.gz"
      sha256 "16d52b93496d6fdd1e4569dcc4e47553a003342cd3d5f3ad2172cf4f06a7033c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.15/candle-0.11.15-linux-arm64.tar.gz"
      sha256 "cf80bba73ce71a83dd8c28f9942cf7e1526298c428b3accfee8b650d2f0ba58f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.15/candle-0.11.15-linux-x64.tar.gz"
      sha256 "b13fc5d9bb1a96a17d309a3be78321951a6c079948c9e8416d57855c1543b75c"
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

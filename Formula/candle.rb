class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.36"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.36/candle-0.11.36-darwin-arm64.tar.gz"
      sha256 "9264eb6258aa1480c662fa5bbd07ed44eec11447070a1bbb87b840b44a9f0c98"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.36/candle-0.11.36-darwin-x64.tar.gz"
      sha256 "b0dea57ed6889e89c739a39877ab54ccda018e682e4ca90070763c0116e622fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.36/candle-0.11.36-linux-arm64.tar.gz"
      sha256 "9dd67d472b3d678f160bfdd794472d85e4eeff5254d12bc378656b10cee70b93"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.36/candle-0.11.36-linux-x64.tar.gz"
      sha256 "cf429acbef4426fc58dc52a2954776a05590cb4547dca7eab8d9d5137505cb3e"
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

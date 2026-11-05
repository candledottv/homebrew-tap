class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.15"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.15/candle-0.13.15-darwin-arm64.tar.gz"
      sha256 "fad66ddb27ca97679c476d39443987d1d776946757f2647b4f8301c87c7a0d13"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.15/candle-0.13.15-darwin-x64.tar.gz"
      sha256 "278cda4c756902a3739f8285f9ad893600430768d00e19fc5c448c2255066a0a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.15/candle-0.13.15-linux-arm64.tar.gz"
      sha256 "53ad7ee2cc1ce67e54fa74abe8d03afb5506cc965cf5a285586afef2785b2ff1"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.15/candle-0.13.15-linux-x64.tar.gz"
      sha256 "3941b1e0a57122c4c221920e744ad2ba76b81dacaa45eec2bb2a0082de61b73c"
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

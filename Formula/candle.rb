class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.47"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.47/candle-0.13.47-darwin-arm64.tar.gz"
      sha256 "32a203dc503408a6612734592cc4ee40fea9c147e713f07e7a47d12548ca77d4"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.47/candle-0.13.47-darwin-x64.tar.gz"
      sha256 "c8970ac4464ad8adcdc6db05365fd21eb06ef1761c090f02f000f6d35999165a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.47/candle-0.13.47-linux-arm64.tar.gz"
      sha256 "55ffb591f6e77bdbbb877ba75fe90a946b7791806ce3d0383c3cc04e9188132e"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.47/candle-0.13.47-linux-x64.tar.gz"
      sha256 "25c3e5676f2ea47ec521b39af4a8aa9edeb8ef46a359a01862d28529bd7e6cc9"
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

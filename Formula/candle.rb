class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.23"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.23/candle-0.13.23-darwin-arm64.tar.gz"
      sha256 "36a927446a1fe99e5dea39dddedb7c256cf5ee92fa8892dbd8eb0049e67208a5"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.23/candle-0.13.23-darwin-x64.tar.gz"
      sha256 "bd6c83c38595a455bbd590ec09b14cf2628a1323f5313a9373ae3584caa201a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.23/candle-0.13.23-linux-arm64.tar.gz"
      sha256 "83cd9975aaa974e100057d5d43a51051403b8c955812f535888e7de3566111e0"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.23/candle-0.13.23-linux-x64.tar.gz"
      sha256 "508b2b9bba5d98cefe7155c132c66f9990cfb9f43e7068852419c92a8f6abcd0"
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

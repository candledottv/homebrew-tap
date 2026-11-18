class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.31"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.31/candle-0.13.31-darwin-arm64.tar.gz"
      sha256 "ef7eb8621cc08ca8ae6509ac252b504d1614d6c94a7c1800cce5128c82cd1063"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.31/candle-0.13.31-darwin-x64.tar.gz"
      sha256 "be4f5b4d5497cf787d6fe93eeab4ed51646e995fb725a4809a7caff93e7182ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.31/candle-0.13.31-linux-arm64.tar.gz"
      sha256 "bbbbe71c53e77155b71a4664d39bb3712775439b9db37195139293e3d9f59c37"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.31/candle-0.13.31-linux-x64.tar.gz"
      sha256 "f17653114e516451c2c799bcfbc8e3083d9e514203d7fdccf793573de6e13b64"
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

class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.19"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.19/candle-0.13.19-darwin-arm64.tar.gz"
      sha256 "3377c054b5326d48bd4658ee0ea2afefb683ddcb7aa3087f8fbbaf3b38215e9a"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.19/candle-0.13.19-darwin-x64.tar.gz"
      sha256 "849e66967c6fd60591d21689ea1b4cbbf403abd668d89677e47444a31e4bf260"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.19/candle-0.13.19-linux-arm64.tar.gz"
      sha256 "efbad4282f91bd6a7b22753eef22d1ffcc45d2401d94fb12f670193d2dfab599"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.19/candle-0.13.19-linux-x64.tar.gz"
      sha256 "1821c64164613d29ca52b32434182adc2fe58ccc15bcf6044f1f58b1dfcfc3e0"
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

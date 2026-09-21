class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.2"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.2/candle-0.11.2-darwin-arm64.tar.gz"
      sha256 "82e25b957da1c05789907885609d2d69dd26972559922b4604d376bb788dea73"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.2/candle-0.11.2-darwin-x64.tar.gz"
      sha256 "f497b034b5d21050b421900876f05dd5991f158f284a9e9f25fa9a79caad8afc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.2/candle-0.11.2-linux-arm64.tar.gz"
      sha256 "83d3527519a3713cc38b301797529bd7251ef9d01635b61c0cfcacbf55a02221"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.2/candle-0.11.2-linux-x64.tar.gz"
      sha256 "29f782d5f274204ae2022230694d864ce5da3f51a07e7a19f9fe2160300fb126"
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

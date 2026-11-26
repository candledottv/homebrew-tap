class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.13.50"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.50/candle-0.13.50-darwin-arm64.tar.gz"
      sha256 "608590829e747dd701831aa09194902f1d918cee82155f3c26c5148b71ecef9e"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.50/candle-0.13.50-darwin-x64.tar.gz"
      sha256 "1d83e29e9bf9d647ae0abfa81b0803ab4fc6ceab88a462255a45a876bdf4bd2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.50/candle-0.13.50-linux-arm64.tar.gz"
      sha256 "fe885e4cd13e890c4a793d3c4bb7392258e15733bc67ceda9061fb8be0e7714a"
    end
    on_intel do
      url "https://github.com/candledottv/cli/releases/download/cli-v0.13.50/candle-0.13.50-linux-x64.tar.gz"
      sha256 "eb15250302b7b996c351907eeb919e88a02515f0cfcaff0b9ca0160342e192e1"
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

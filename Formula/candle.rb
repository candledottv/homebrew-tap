class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.5"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.5/candle-0.11.5-darwin-arm64.tar.gz"
      sha256 "3ee088e673c2e152f47068e5033231c680b50bc352a03714641f7196ce40ee96"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.5/candle-0.11.5-darwin-x64.tar.gz"
      sha256 "c5e77583b9ad4d666025e665b0f9143ed68003d251bbfd20721e04a5eba9ac02"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.5/candle-0.11.5-linux-arm64.tar.gz"
      sha256 "a4b48434dffcb1503ff91f6771c9bdf246f4bf4fb015074f62c51fdb579ac1cb"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.5/candle-0.11.5-linux-x64.tar.gz"
      sha256 "982dea745cd329a492689f46529d003407f9ce7180cb79e02699c278cc15f5bf"
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

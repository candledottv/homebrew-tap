class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.16"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.16/candle-0.11.16-darwin-arm64.tar.gz"
      sha256 "53064ed13b061290d18132ceac90ceca05aed345a288523b19f0a11a9227f47b"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.16/candle-0.11.16-darwin-x64.tar.gz"
      sha256 "8b04547a45fa50ee3c84ca1f724430b5f1d0924d5ffce39c6210aec6305b511f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.16/candle-0.11.16-linux-arm64.tar.gz"
      sha256 "caa1d02a69443c7804e4fff4670f5253bc698ad606036f445306b230fa36a081"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.16/candle-0.11.16-linux-x64.tar.gz"
      sha256 "62741406fd3c803c471244fff047b921fb502ac209aa9c107f1ecfe053290499"
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

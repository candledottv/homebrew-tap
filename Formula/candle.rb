class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.11"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.11/candle-0.11.11-darwin-arm64.tar.gz"
      sha256 "38ec1926cedb82d6da0914d576497422b5effa1342142ed5bae7db6e78f97ecb"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.11/candle-0.11.11-darwin-x64.tar.gz"
      sha256 "d28498bb1ef53ab1b43ee85c7f7b8a87dc483cc38d7c88c754963537681dae68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.11/candle-0.11.11-linux-arm64.tar.gz"
      sha256 "53311f1946dcffd257abd8cfe63126129e14f20ed0dc5ef392a3b8287153ed00"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.11/candle-0.11.11-linux-x64.tar.gz"
      sha256 "ef955c127e47a0804f46a95608f8b810ce4c99baeb8cb660ae6fa3dd125c2967"
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

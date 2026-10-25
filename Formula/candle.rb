class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.11.41"
  license "MIT"

  # The security key helper (candle-fido2) loads libfido2 at run time; Homebrew's is the one it finds.
  depends_on "libfido2"

  on_macos do
    # The darwin binaries are linked for macOS 13 or later (minos 13.0) and are not built to run on
    # macOS 12. Inside on_macos on purpose: a top-level `depends_on macos:` makes Homebrew treat the
    # whole formula as macOS-only (Formula#supports_linux? turns false).
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.41/candle-0.11.41-darwin-arm64.tar.gz"
      sha256 "a7e22d7d06dd211214f9ffa0fa87e4306000a7e1c2aca6fbdb1d5d2758d98318"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.41/candle-0.11.41-darwin-x64.tar.gz"
      sha256 "ce35f918235929511de368a5a9d9e7b7fd5ecf393424ba1edb023f6f49e9a285"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.41/candle-0.11.41-linux-arm64.tar.gz"
      sha256 "23821e46750273ec46fbf31a5904f9d49470399b92205c0266bdfc9477fec76f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.11.41/candle-0.11.41-linux-x64.tar.gz"
      sha256 "9abb9ffa3a13f8c3d3b82c8e45a6df7b6e6e72d378a611818b5f880cf078cafb"
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

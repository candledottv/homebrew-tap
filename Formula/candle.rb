class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.1/candle-0.8.1-darwin-arm64.tar.gz"
      sha256 "7ce089481f7a70d895b0a5178ca6bd737df285669c08a2fd7f3612f5063de465"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.1/candle-0.8.1-darwin-x64.tar.gz"
      sha256 "5e740e1b415523aaff497cd7e488bc7fbef05117949a3bc7ff3a97ea9ab6dda3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.1/candle-0.8.1-linux-arm64.tar.gz"
      sha256 "5a11ac3d06c71647e373d4ec07425fb3a5106ece95898f584e06de161cd453ca"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.1/candle-0.8.1-linux-x64.tar.gz"
      sha256 "67137efea1cc379115e497c0729a1e56bda82176f6552cb43855da782594733f"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

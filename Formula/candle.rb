class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.8.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.4/candle-0.8.4-darwin-arm64.tar.gz"
      sha256 "1916d60f1a4e33bd04f7298203bc8a14a23b8f7512cf999b1639b82f18f8a8c1"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.4/candle-0.8.4-darwin-x64.tar.gz"
      sha256 "dd48e6be1ba2f0dd3119f3514974aab13fa97aeb113fc03f4d55c203e4f31267"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.4/candle-0.8.4-linux-arm64.tar.gz"
      sha256 "ab61bb90046b54bc523e17fa80ba062eedb1f2d700a99082ddc33d50bf83a3b9"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.4/candle-0.8.4-linux-x64.tar.gz"
      sha256 "73796e5bd10dacd93a9567c82dfeacd2735457d2546c415722fd32b1e9761853"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

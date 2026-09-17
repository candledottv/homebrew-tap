class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.9.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.2/candle-0.9.2-darwin-arm64.tar.gz"
      sha256 "2aa82f4dee451f7bdd13c34d1ad140100c77edd8520381128fc6e83a4b7564a6"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.2/candle-0.9.2-darwin-x64.tar.gz"
      sha256 "b66ddd90c7290765190b324cc68d170cec1617198ad1201e39bb5c6f27266a7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.2/candle-0.9.2-linux-arm64.tar.gz"
      sha256 "4310e0ec4d5d3a1940ca38a29ef514372d7346a0ad29f7d98580a801f79b1ca3"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.2/candle-0.9.2-linux-x64.tar.gz"
      sha256 "7b7e5e966deda82e9e0d18c22e17d189c8abc85057ebd8e920478cdddc5ec36b"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.10.0/candle-0.10.0-darwin-arm64.tar.gz"
      sha256 "55d8436cfee982aea99432f76130411133673d5067b8f04a58877600b6d5a8f7"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.10.0/candle-0.10.0-darwin-x64.tar.gz"
      sha256 "69905b4cf709a7011919402c5bda3253ab4159ee4995b2ce1831b966921b5325"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.10.0/candle-0.10.0-linux-arm64.tar.gz"
      sha256 "f1fcc3e5ba530d3298f0d17ea99610a82007c14f44bbf4629c7a3b7b15e5fe10"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.10.0/candle-0.10.0-linux-x64.tar.gz"
      sha256 "33723679cf23a76b5d42ce6059a4037993b097ef6d0b557f31e8724bb4d11dd5"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

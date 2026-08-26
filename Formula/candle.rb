class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.0.0/candle-0.0.0-darwin-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.0.0/candle-0.0.0-darwin-x64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.0.0/candle-0.0.0-linux-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.0.0/candle-0.0.0-linux-x64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

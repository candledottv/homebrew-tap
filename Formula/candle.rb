class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.7.0/candle-0.7.0-darwin-arm64.tar.gz"
      sha256 "f34a45926194d31df548888bc588db3520471a4e2d412450015b58eaaef2ba60"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.7.0/candle-0.7.0-darwin-x64.tar.gz"
      sha256 "1bac78b2ad6f40d6969595c3f350d0d07bcd9295f82a24379592d228c0757232"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.7.0/candle-0.7.0-linux-arm64.tar.gz"
      sha256 "24ceebe299805da489fce89fabfb332d4e63386790717043d8747d3ac1c95af8"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.7.0/candle-0.7.0-linux-x64.tar.gz"
      sha256 "3238e38099d3ad88527fcc3629c74054a0fb7a67b0dbe34a63b95edff8645cf5"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

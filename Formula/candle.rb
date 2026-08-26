class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.2/candle-0.6.2-darwin-arm64.tar.gz"
      sha256 "1e03f5de14ec016a64398648a6452930cd642e5666dfcd6a0683922453e1dd19"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.2/candle-0.6.2-darwin-x64.tar.gz"
      sha256 "b74acb07b945c15ff1e5f9ae170073d113655106b707139daa88dcd1d185dcdf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.2/candle-0.6.2-linux-arm64.tar.gz"
      sha256 "f6e647d0e3ce64833959fbda961e59f5211027468901e143d800fc2cf9c144d3"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.2/candle-0.6.2-linux-x64.tar.gz"
      sha256 "5f9d679fca151aa2e8d2aec8b5fa5dbb1eb14e6386683854335e0f651a396342"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

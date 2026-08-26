class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.6.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.1/candle-0.6.1-darwin-arm64.tar.gz"
      sha256 "13d77b8e1455f97b951f4b46a5d59777ce0c753d3e974394b598bcf11fa9aea5"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.1/candle-0.6.1-darwin-x64.tar.gz"
      sha256 "6c98206d17c1f7714be85e7d9fbb51fb98534418deb11319f832a923b24d6fbb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.1/candle-0.6.1-linux-arm64.tar.gz"
      sha256 "dfb5618dabcd55c609fb884d6b5417b2d390439f7e059b2276abbaefc1f9371f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.1/candle-0.6.1-linux-x64.tar.gz"
      sha256 "62e67147f9738dea0660cb2cce9f8814b4f491aedad85bdd31bb3de34d8199ac"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

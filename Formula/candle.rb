class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.8.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.3/candle-0.8.3-darwin-arm64.tar.gz"
      sha256 "24cae7505f06264152497076e05c8383a01e9080a45e08b4a576a9b5ab77662d"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.3/candle-0.8.3-darwin-x64.tar.gz"
      sha256 "5006bde86d45cdfc2d375c3b01a9e74c494c409068cd1c9acfab01adc332cf20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.3/candle-0.8.3-linux-arm64.tar.gz"
      sha256 "3a42200934c82981417b22ff47cb40ed57a01bb1ef2895ee83a4607fe0176b45"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.3/candle-0.8.3-linux-x64.tar.gz"
      sha256 "5e362131c60c3aeea694667cf00ad0ce2da24de4cf03e75db4015a0a9c42e1dd"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

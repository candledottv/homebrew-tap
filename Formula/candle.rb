class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.0/candle-0.8.0-darwin-arm64.tar.gz"
      sha256 "cdf08d29ed6dea4c22175341a2d26aa273dac9d668220576363ab9ac849a322f"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.0/candle-0.8.0-darwin-x64.tar.gz"
      sha256 "a92def08f7218b8ef24aee885c06055fe2fe82f28b53db2e6079de4ef697c6a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.0/candle-0.8.0-linux-arm64.tar.gz"
      sha256 "b25e995d242891a825352b57a5a3a8ed21b8175a0399ae737861a13c8a62585c"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.0/candle-0.8.0-linux-x64.tar.gz"
      sha256 "520b9d81f54d0bb60d4746b5750e135c356fb7be3cbff09dc84496b63378ecce"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

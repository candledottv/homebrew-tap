class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.0/candle-0.9.0-darwin-arm64.tar.gz"
      sha256 "1ccf62bc01a357642a496ca7e8fa6565f369cbb4744ab565ee22bd4362a89d28"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.0/candle-0.9.0-darwin-x64.tar.gz"
      sha256 "66dfe129d44d3e721d6673eb0588425ff805c0659bb890d06f87e970e4be59e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.0/candle-0.9.0-linux-arm64.tar.gz"
      sha256 "1557b93a0a9547d8c47accc74b60b6ab04d64ea76f74277acafed4075bc47193"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.9.0/candle-0.9.0-linux-x64.tar.gz"
      sha256 "d374b642fac5164504eab1b5fbc0101b29a2619f69be638d971838ff1b19240c"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

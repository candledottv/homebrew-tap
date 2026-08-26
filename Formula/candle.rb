class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.0/candle-0.6.0-darwin-arm64.tar.gz"
      sha256 "bd9ae98a1aa6523601306cbe6459e16f25dfc2565e349b04b8cddc0df9295a54"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.0/candle-0.6.0-darwin-x64.tar.gz"
      sha256 "9260fea609e5bcc0fe6ec62b992a726226f78ccb52a2a7166d04b9fc34fac380"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.0/candle-0.6.0-linux-arm64.tar.gz"
      sha256 "d323dd586753342316ea6b81e0f8a22c08c1e3a0618ff1bf9902410a5110ffdd"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.6.0/candle-0.6.0-linux-x64.tar.gz"
      sha256 "d01a91e861ecb5481eb90239026188021628c193705fe9c850d40dc86e3cb53f"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

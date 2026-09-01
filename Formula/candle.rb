class Candle < Formula
  desc "Authorize a device, manage API keys and wallets, run the MCP server"
  homepage "https://candle.tv"
  version "0.8.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.2/candle-0.8.2-darwin-arm64.tar.gz"
      sha256 "45b709a94b4d7b927571caa74e73eeff651c2455f7b1fd240fa2e22cc34beba8"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.2/candle-0.8.2-darwin-x64.tar.gz"
      sha256 "0f180d2d9d7ccc4483e0c6bde9e841532ac6d1e65df4653527b4d58f03872b40"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.2/candle-0.8.2-linux-arm64.tar.gz"
      sha256 "221ef9008a871b66ee6f4f747b1a741843a0208ae168b5b43f5f40008edeab83"
    end
    on_intel do
      url "https://github.com/candledottv/agentic/releases/download/cli-v0.8.2/candle-0.8.2-linux-x64.tar.gz"
      sha256 "9f444a410bfaaebd832fa0f58f2bfcd17e398b517bdff4f5210cd9f28507e204"
    end
  end

  def install
    bin.install "candle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/candle --version")
  end
end

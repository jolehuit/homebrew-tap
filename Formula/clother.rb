class Clother < Formula
  desc "Switch between Claude Code-compatible LLM providers from one CLI"
  homepage "https://github.com/jolehuit/clother"
  url "https://github.com/jolehuit/clother/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "3636c0c734a8ed50e0976d287c276e62ef7b1953c0da09d9b50e009d4df5b9f5"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jolehuit/clother/internal/version.Value=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clother"
  end

  def caveats
    <<~EOS
      Run the following command to create provider launcher symlinks
      (clother-zai, clother-kimi, etc.) in ~/bin:
        clother install

      Symlinks point directly to the Homebrew-managed binary, so
      `brew upgrade clother` keeps them up to date automatically.
      You can also run `clother update` which routes to brew upgrade.

      Claude Code CLI must be installed separately:
        curl -fsSL https://claude.ai/install.sh | bash
    EOS
  end

  test do
    assert_match "Clother v#{version}", shell_output("#{bin/"clother"} --version")
  end
end

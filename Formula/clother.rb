class Clother < Formula
  desc "Switch between Claude Code-compatible LLM providers from one CLI"
  homepage "https://github.com/jolehuit/clother"
  url "https://github.com/jolehuit/clother/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "595bd2d2f0ea22d922a853c7a05d079e9fadc5fbd8833a6e13de1a0f40c1ff42"
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
      After installing Claude Code, run:
        clother install
      to create the provider launcher symlinks (clother-zai, clother-kimi, etc.)
      in ~/bin (macOS) or ~/.local/bin (Linux).

      Symlinks are created as absolute references to the Homebrew binary, so
      `brew upgrade clother` propagates automatically without re-running
      `clother install`.

      Claude Code CLI must be installed separately:
        curl -fsSL https://claude.ai/install.sh | bash
    EOS
  end

  test do
    assert_match "Clother v#{version}", shell_output("#{bin}/clother --version")
  end
end

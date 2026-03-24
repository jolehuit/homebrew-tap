class Clother < Formula
  desc "Switch between Claude Code-compatible LLM providers from one CLI"
  homepage "https://github.com/jolehuit/clother"
  url "https://github.com/jolehuit/clother/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "ae5b67d531c3c43f9ce52ea359c01ad72ce17ccb84e3560abef1759a51c79ea0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jolehuit/clother/internal/version.Value=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clother"

    # Static provider launchers — available immediately after brew install.
    %w[
      native
      zai zai-cn
      minimax minimax-cn
      kimi moonshot
      deepseek
      mimo
      alibaba alibaba-us alibaba-cn
      ve
      ollama lmstudio llamacpp
    ].each do |provider|
      bin.install_symlink bin/"clother" => "clother-#{provider}"
    end

    # Gateway symlinks for dynamic providers (OpenRouter aliases, custom).
    # Usage: clother-or <alias>  /  clother-custom <provider-name>
    bin.install_symlink bin/"clother" => "clother-or"
    bin.install_symlink bin/"clother" => "clother-custom"
  end

  def caveats
    <<~EOS
      Claude Code CLI must be installed separately:
        curl -fsSL https://claude.ai/install.sh | bash

      All provider launchers (clother-native, clother-zai, clother-kimi, etc.)
      are already available in #{HOMEBREW_PREFIX}/bin — no extra setup needed.

      For OpenRouter aliases or custom providers, configure first then use the
      gateway launchers:
        clother config openrouter
        clother-or <alias> [args...]

        clother config custom
        clother-custom <provider-name> [args...]
    EOS
  end

  test do
    assert_match "Clother v#{version}", shell_output("#{bin/"clother"} --version")
    output = shell_output("#{bin/"clother"} list 2>&1")
    assert_match "native", output
  end
end

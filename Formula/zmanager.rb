class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction (offline signer)"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.2.1"
  license all_of: ["Apache-2.0", :cannot_represent]


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.2.1/zm-aarch64-apple-darwin.tar.gz"
      sha256 "533d1b0589f103544b59ba725d5b7a222f3d9f699287a30c55e00c6ef813fc20"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.2.1/zm-x86_64-apple-darwin.tar.gz"
      sha256 "6d91b910a81d1012f509362cf493120bad3ad9a56ea3472173d820306d5c226b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.2.1/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf5f5defd98eb8d8073099e615832bb686d84656bd40d366c14b58bbd0e94b0d"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.2.1/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc290076b865c64b5e50b5af7f6615fb13b8959f5c93b7dfb3dc997806f12952"
    end
  end

  def install
    bin.install "zm"
    man1.install "man/man1/zm.1"
    bash_completion.install "completions/zm.bash" => "zm"
    zsh_completion.install "completions/_zm" => "_zm"
    fish_completion.install "completions/zm.fish"
    doc.install "README.md", "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md"
  end

  def caveats
    <<~EOS
      Shell completions are installed for bash, zsh, and fish.
      Bash users can enable completion without extra packages by adding:
        source #{HOMEBREW_PREFIX}/etc/bash_completion.d/zm

      Or generate completions manually:
        source <(zm completions bash)

      PowerShell users can generate a completer manually:
        zm completions powershell > zm.ps1
    EOS
  end

  test do
    assert_match "zm #{version}", shell_output("#{bin}/zm --version")

    (testpath/"payload.txt").write("hello from Homebrew\n")
    system bin/"zm", "create", "payload.zip", "payload.txt"
    system bin/"zm", "test", "payload.zip"
  end
end

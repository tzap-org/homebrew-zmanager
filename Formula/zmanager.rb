class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction (offline signer)"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.3.0"
  license all_of: ["Apache-2.0", :cannot_represent]


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-aarch64-apple-darwin.tar.gz"
      sha256 "bb08de2961c6e42319f17acf2a27c43c523f188f347f7d5b3593a291504069ba"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-x86_64-apple-darwin.tar.gz"
      sha256 "f4662f44bcaee3108c41952dcb9157858a9a6520a46d0989d92aba472dccf0bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3a3bd2c41026a5ef39be99cf046f72bf5a54b4c78b6a849777287361b0d13bbc"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e56295894b0aa16c142c00e975b643d059b67a8e899ed0b0e8f3ef39c5d1aa7b"
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

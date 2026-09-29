class Zmanager < Formula
  desc "Universal file archiver for fast compression and safe extraction (offline signer)"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.1.7"
  license all_of: ["Apache-2.0", :cannot_represent]


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.7/zm-aarch64-apple-darwin.tar.gz"
      sha256 "81d78b997a44669adcbc383c9c619787c5209042a6d24dd962d10961ece50a5d"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.7/zm-x86_64-apple-darwin.tar.gz"
      sha256 "93561c74448881db54253e209ac3dd543a78307eaf93d54f8a5923dde1ae694e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.7/zm-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1be30db3f029a2bf2cbd5a20338f14db70dc8bc18f4b84bdba70af116167502c"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.1.7/zm-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8a46fab7a955af408e3b1feec3dd4d8a8cc59a9df73c9da47ac1fe1377a23e26"
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

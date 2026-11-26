class ZmanagerFull < Formula
  desc "Universal file archiver with hosted identity and enrollment support"
  homepage "https://github.com/tzap-org/zmanager"
  version "2.3.0"
  license all_of: ["Apache-2.0", :cannot_represent]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-full-aarch64-apple-darwin.tar.gz"
      sha256 "1a74efa3195cf47940e25921bcd55049273d9b5c9e4471a7b536cd9c9df26a0f"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-full-x86_64-apple-darwin.tar.gz"
      sha256 "c3d8787fb423b66c22a056478014f89b5e228c8ee2cc5be8dd091670a699b177"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-full-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e314de1b3c1e8247ac873d8f12e46aa8f853959bda1fed889721948cab3a6b48"
    else
      url "https://github.com/tzap-org/zmanager/releases/download/v2.3.0/zm-full-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bac99cbd0c15a96ce2e6db4b96977b5964ebbf5c924844bb196d804a633db375"
    end
  end

  def install
    bin.install "zm-full" => "zm"
    man1.install "man/man1/zm.1"
    bash_completion.install "completions/zm.bash" => "zm"
    zsh_completion.install "completions/_zm" => "_zm"
    fish_completion.install "completions/zm.fish"
    doc.install "README.md", "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md"
  end

  test do
    assert_match "zm #{version}", shell_output("#{bin}/zm --version")
    (testpath/"payload.txt").write("hello from Homebrew\n")
    system bin/"zm", "create", "payload.zip", "payload.txt"
    system bin/"zm", "test", "payload.zip"
  end
end

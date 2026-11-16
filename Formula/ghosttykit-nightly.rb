class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-43895391528-8f13dad"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43895391528-8f13dad/ghosttykit_0.8.2-dev-43895391528-8f13dad_darwin_arm64.zip"
      sha256 "18bf0297e7270593b923dc4be16ff79291ade4b92b51d51561c9fec707d94631"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43895391528-8f13dad/ghosttykit_0.8.2-dev-43895391528-8f13dad_linux_arm64.zip"
      sha256 "83042b849793415e50c0c6dd49f0b767ad9cf11f04a8fed1ac0fc0d1a463c47a"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43895391528-8f13dad/ghosttykit_0.8.2-dev-43895391528-8f13dad_linux_amd64.zip"
      sha256 "8a12c7c78aa91c740982ca8fffe43ce80887bf630011a6be04a3c6c562f1b432"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty"

  def install
    bin.install "bin/gty"
    return unless OS.mac?

    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run macos: [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    notice = "This formula tracks nightly builds from GhosttyKit main and may break.\n\n"
    if OS.mac?
      notice + <<~EOS
        Start Ghostty, then start the GhosttyKit daemon:

          brew services start #{full_name}

        On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
        Grant access, then verify the install with:

          gty doctor
      EOS
    else
      notice + <<~EOS
        This installs the gty CLI only. The GhosttyKit daemon is macOS-only, so gty here
        serves SSH sessions bridged from a macOS host by gty ssh.
      EOS
    end
  end

  test do
    assert_match "gty 0.8.2-dev-43895391528-8f13dad protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-43895391528-8f13dad", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

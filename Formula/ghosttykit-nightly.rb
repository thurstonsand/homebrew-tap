class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-37484079996-7b49e83"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37484079996-7b49e83/ghosttykit_0.6.1-dev-37484079996-7b49e83_darwin_arm64.zip"
      sha256 "db5bcde1da48024cf6b813766a0f06f97585632b234d95bbbd43e46b09a6d2a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37484079996-7b49e83/ghosttykit_0.6.1-dev-37484079996-7b49e83_linux_arm64.zip"
      sha256 "75159bfae401d1b62d924da5a5037337fd4204a30e59dbb09bfa05064e629ff6"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-37484079996-7b49e83/ghosttykit_0.6.1-dev-37484079996-7b49e83_linux_amd64.zip"
      sha256 "a944898320629e0635d162b88777491dcee6e79e9ff4e1b9e35ad252fecb6fc2"
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
    assert_match "gty 0.6.1-dev-37484079996-7b49e83 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-37484079996-7b49e83", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

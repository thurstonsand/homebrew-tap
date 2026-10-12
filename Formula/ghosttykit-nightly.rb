class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.1-dev-38253921815-0ff2646"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38253921815-0ff2646/ghosttykit_0.7.1-dev-38253921815-0ff2646_darwin_arm64.zip"
      sha256 "6dabc872a46902d95178528779f6b9918a11fbe4f44eb3c5db11f01f5788323d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38253921815-0ff2646/ghosttykit_0.7.1-dev-38253921815-0ff2646_linux_arm64.zip"
      sha256 "aaae78458b7f7c0ac8ed07cbe988c5bf1285749e3a32f3dafde43d537afe691b"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.1-dev-38253921815-0ff2646/ghosttykit_0.7.1-dev-38253921815-0ff2646_linux_amd64.zip"
      sha256 "b5a93c6809b127691a904fad9e593f577b6912403ea983dd34c0e0d0fec3e2b3"
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
    assert_match "gty 0.7.1-dev-38253921815-0ff2646 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1-dev-38253921815-0ff2646", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

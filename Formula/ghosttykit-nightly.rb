class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.2-dev-43883021462-4ab132e"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43883021462-4ab132e/ghosttykit_0.8.2-dev-43883021462-4ab132e_darwin_arm64.zip"
      sha256 "11deb5cf616b297e1497274da09f891e50a26c87c371d7ae7282e5bf54255551"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43883021462-4ab132e/ghosttykit_0.8.2-dev-43883021462-4ab132e_linux_arm64.zip"
      sha256 "41e7548cf1b4546ecd143b9d453712052e5126834f0318f32fa41c6de26e93f3"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.2-dev-43883021462-4ab132e/ghosttykit_0.8.2-dev-43883021462-4ab132e_linux_amd64.zip"
      sha256 "993e10f3cdd8875d175bf26aa6bc9c2d05addd3da01b5a3cf51590717ba55b08"
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
    assert_match "gty 0.8.2-dev-43883021462-4ab132e protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.2-dev-43883021462-4ab132e", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

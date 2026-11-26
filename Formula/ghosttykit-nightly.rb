class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.3-dev-45885001153-cf1862e"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45885001153-cf1862e/ghosttykit_0.8.3-dev-45885001153-cf1862e_darwin_arm64.zip"
      sha256 "e80a518ed0555d9bc2543d9175894f24caf2b124f66b1ce1bebc8d2d0a2f9759"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45885001153-cf1862e/ghosttykit_0.8.3-dev-45885001153-cf1862e_linux_arm64.zip"
      sha256 "aedb40fbb5c227dd55b1fd6ae42e2d6a1c60eecc05db465966c8f98d27aef987"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45885001153-cf1862e/ghosttykit_0.8.3-dev-45885001153-cf1862e_linux_amd64.zip"
      sha256 "e72dbb3827b061f1d9a8a776928a547d87c86664d4808ca4590d8fc29acea6be"
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
    assert_match "gty 0.8.3-dev-45885001153-cf1862e protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.3-dev-45885001153-cf1862e", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

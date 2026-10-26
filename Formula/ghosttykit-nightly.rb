class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-40328560952-70f2bc1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40328560952-70f2bc1/ghosttykit_0.7.2-dev-40328560952-70f2bc1_darwin_arm64.zip"
      sha256 "710a1645c29c7c8aa9bae91f4c3f98bf557048d6a25955b4bc3f6122fcbe04d6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40328560952-70f2bc1/ghosttykit_0.7.2-dev-40328560952-70f2bc1_linux_arm64.zip"
      sha256 "4974fee4bbdab93d6e136d4da42f91c6e8dd3507a5e96f8ef034c79b17ec5906"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-40328560952-70f2bc1/ghosttykit_0.7.2-dev-40328560952-70f2bc1_linux_amd64.zip"
      sha256 "b25dcf77c3d205fcfdbd9d6fcec814853eebe654dcd6ce412378d45d03214023"
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
    assert_match "gty 0.7.2-dev-40328560952-70f2bc1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-40328560952-70f2bc1", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

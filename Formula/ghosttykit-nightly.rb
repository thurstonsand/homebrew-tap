class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-39542061296-5d09e9b"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39542061296-5d09e9b/ghosttykit_0.7.2-dev-39542061296-5d09e9b_darwin_arm64.zip"
      sha256 "61a03295dd1528433766dde210018ec7fe1b474342609941c5913de1b0d4425d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39542061296-5d09e9b/ghosttykit_0.7.2-dev-39542061296-5d09e9b_linux_arm64.zip"
      sha256 "f6d29eefda75e46968e80b2219aaaf899956c144ec5f290184402207c136622f"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39542061296-5d09e9b/ghosttykit_0.7.2-dev-39542061296-5d09e9b_linux_amd64.zip"
      sha256 "7f93429acf3fa11b5bdd0b98c59f9cbeeaf760ed2cfde6f139950052a40ac3a6"
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
    assert_match "gty 0.7.2-dev-39542061296-5d09e9b protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-39542061296-5d09e9b", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

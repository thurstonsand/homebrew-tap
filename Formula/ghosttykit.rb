class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.1/ghosttykit_0.7.1_darwin_arm64.zip"
      sha256 "7dda671dcaeec6f4c7a0fe98f80e1242b655ba0e3db406cb14a9c04d72e7b4d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.1/ghosttykit_0.7.1_linux_arm64.zip"
      sha256 "8970ef57eb3129cc5b43f83c6432e8acc6456a93599b20e1377e4b0a8041860d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.1/ghosttykit_0.7.1_linux_amd64.zip"
      sha256 "828c76fb7294c1cbe85e2800ac22913afb7a84b4a740307401655a5679796909"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty"

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
    notice = ""
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
    assert_match "gty 0.7.1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.1", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

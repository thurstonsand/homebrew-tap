class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.1/ghosttykit_0.8.1_darwin_arm64.zip"
      sha256 "0aa28a9ecb4250a2d9cc7df8d25b6b9e4cc70b2c9faeaebfe39c1a51997fa08e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.1/ghosttykit_0.8.1_linux_arm64.zip"
      sha256 "13953d597e5bc39c70373f145ce153f65f3fecf491598d9f7624e54cebf112a9"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.8.1/ghosttykit_0.8.1_linux_amd64.zip"
      sha256 "5bf7fdb23c8b4fc5113a817d293f55b887a5d7cac6d4f4b0be37c94fa6b4cfa8"
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
    assert_match "gty 0.8.1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.1", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

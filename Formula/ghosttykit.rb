class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.0/ghosttykit_0.7.0_darwin_arm64.zip"
      sha256 "9a26db7a9ab3614ba19d32410aefdaa31b69576456c91fc6627ea6215e1c7e78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.0/ghosttykit_0.7.0_linux_arm64.zip"
      sha256 "1605d8bd2576322b7f52127082f9e626e1cc83bde4af14cd2b28e727d2bc8fd3"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.7.0/ghosttykit_0.7.0_linux_amd64.zip"
      sha256 "2f0dd3803004871f72b8406a3125eb69b782cce30ec98995e6a1f6b7fb774373"
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
    assert_match "gty 0.7.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.0", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

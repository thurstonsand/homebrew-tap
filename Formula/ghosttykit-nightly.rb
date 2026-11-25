class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.3-dev-45668391610-29890d9"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45668391610-29890d9/ghosttykit_0.8.3-dev-45668391610-29890d9_darwin_arm64.zip"
      sha256 "a175e55782b1fd1acc3ac7b6392f68ea64439afc0f0d097e5bd9456fe309d0f6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45668391610-29890d9/ghosttykit_0.8.3-dev-45668391610-29890d9_linux_arm64.zip"
      sha256 "38bb0e39d5070a7190b74ee1cf6fc8773e3c0e5d7e115c11eda00281cf12c60f"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45668391610-29890d9/ghosttykit_0.8.3-dev-45668391610-29890d9_linux_amd64.zip"
      sha256 "3e72af9da8004e18278f4098741a18e92d7960363944c6ab130853c43cb00762"
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
    assert_match "gty 0.8.3-dev-45668391610-29890d9 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.3-dev-45668391610-29890d9", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

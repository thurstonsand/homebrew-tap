class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-30731384088-1f609cd"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30731384088-1f609cd/ghosttykit_0.4.0-dev-30731384088-1f609cd_darwin_arm64.zip"
      sha256 "f186e61ed5141a75dce780bc5e746e64a74cbda6844814aafeedeb3d620ffda6"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30731384088-1f609cd/ghosttykit_0.4.0-dev-30731384088-1f609cd_darwin_amd64.zip"
      sha256 "ef086a5bff045798ba88681842bf1d6da3673fa7e816525c8fc6a1c039f3f9bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30731384088-1f609cd/ghosttykit_0.4.0-dev-30731384088-1f609cd_linux_arm64.zip"
      sha256 "154cf4fee4283bc6d4d191d6f17dc0766c7765bb948acb1972327b31e77449e9"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-30731384088-1f609cd/ghosttykit_0.4.0-dev-30731384088-1f609cd_linux_amd64.zip"
      sha256 "d15c6341a5c718a724c7f4d970ab47cf09a05423b19c565a177b453aff025dea"
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
    assert_match "gty 0.4.0-dev-30731384088-1f609cd protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-30731384088-1f609cd", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

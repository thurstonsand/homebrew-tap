class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32797877363-2f90318"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32797877363-2f90318/ghosttykit_0.6.1-dev-32797877363-2f90318_darwin_arm64.zip"
      sha256 "8988f6aae96efdf8b2cd66cf0b1b64a5d61d340b26b4b0d2cf92619f86084c25"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32797877363-2f90318/ghosttykit_0.6.1-dev-32797877363-2f90318_darwin_amd64.zip"
      sha256 "f2ca81565f40664361b05258e8b045a472e5a0a127f3bb1da884562cd57d5f4a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32797877363-2f90318/ghosttykit_0.6.1-dev-32797877363-2f90318_linux_arm64.zip"
      sha256 "2a85416f4af397e50120fd02c26a2b9a07173cf2233ad6ef29ffe75b8153a01c"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32797877363-2f90318/ghosttykit_0.6.1-dev-32797877363-2f90318_linux_amd64.zip"
      sha256 "dbc9ccbbe2e47a33ad1c78fa22fa71282e7c719a97cc1eb7c6377625e5eb5488"
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
    assert_match "gty 0.6.1-dev-32797877363-2f90318 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32797877363-2f90318", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

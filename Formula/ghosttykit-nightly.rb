class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32070256384-c89a6ac"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32070256384-c89a6ac/ghosttykit_0.6.1-dev-32070256384-c89a6ac_darwin_arm64.zip"
      sha256 "b36acc5d3036ac00417a68b19b9367a2c2189e917033ab128746ac6c5869818e"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32070256384-c89a6ac/ghosttykit_0.6.1-dev-32070256384-c89a6ac_darwin_amd64.zip"
      sha256 "f3f5284d335dcacbbd7d0599b9dc471b91f46d3277fa40f58f520f000a571d25"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32070256384-c89a6ac/ghosttykit_0.6.1-dev-32070256384-c89a6ac_linux_arm64.zip"
      sha256 "6f8902a17414fe4880cae66168a949a577e41601f9ace75a3571de8cc2309803"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32070256384-c89a6ac/ghosttykit_0.6.1-dev-32070256384-c89a6ac_linux_amd64.zip"
      sha256 "58b3a642a457270e122b7a2c305b3693dbf01241de76bf452382cbe324a0c39d"
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
    assert_match "gty 0.6.1-dev-32070256384-c89a6ac protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32070256384-c89a6ac", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

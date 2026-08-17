class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.6.1-dev-32069495903-49eeb6c"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32069495903-49eeb6c/ghosttykit_0.6.1-dev-32069495903-49eeb6c_darwin_arm64.zip"
      sha256 "a5672eb0afe3fd3cfe412f7a90fa47a32e37c4957d39350a5dfd34311e15e69d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32069495903-49eeb6c/ghosttykit_0.6.1-dev-32069495903-49eeb6c_darwin_amd64.zip"
      sha256 "bb017af9f53068dfaa02d98b32eb17cb2f6ab451ca9f8ffac4a0cb5c62a43419"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32069495903-49eeb6c/ghosttykit_0.6.1-dev-32069495903-49eeb6c_linux_arm64.zip"
      sha256 "571fe6a9de6709ce38768e5c437940166a747445853ccf82de89a73660b33896"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.6.1-dev-32069495903-49eeb6c/ghosttykit_0.6.1-dev-32069495903-49eeb6c_linux_amd64.zip"
      sha256 "3a28b9a1acb122ac303883e78f39a04a0c287f90157066174cd09ef503b905ec"
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
    assert_match "gty 0.6.1-dev-32069495903-49eeb6c protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.6.1-dev-32069495903-49eeb6c", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

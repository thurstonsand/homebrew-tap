class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-41462733504-a5a3949"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41462733504-a5a3949/ghosttykit_0.7.2-dev-41462733504-a5a3949_darwin_arm64.zip"
      sha256 "11104c7ddb2b7575e7224136a8b1fe54a11f6983eef12134a217f9b9790c64cb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41462733504-a5a3949/ghosttykit_0.7.2-dev-41462733504-a5a3949_linux_arm64.zip"
      sha256 "8bd3ef1569e34af03da7d0fc9f3d3bc90f9fa4941fb14126f70fe43a3097affb"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-41462733504-a5a3949/ghosttykit_0.7.2-dev-41462733504-a5a3949_linux_amd64.zip"
      sha256 "fbc917cf7cd80a0905d8b6d25cd0d692d7ecc239a562d80f9a75b01360e1a977"
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
    assert_match "gty 0.7.2-dev-41462733504-a5a3949 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-41462733504-a5a3949", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

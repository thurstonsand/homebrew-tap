class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.5.1-dev-30733675827-db09271"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30733675827-db09271/ghosttykit_0.5.1-dev-30733675827-db09271_darwin_arm64.zip"
      sha256 "54696ddf62c7af76eb3276c715177f09303796b103debb5196fbc065b1c80a49"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30733675827-db09271/ghosttykit_0.5.1-dev-30733675827-db09271_darwin_amd64.zip"
      sha256 "db74dd27b368d254f12a5351e3c03cb0cc04564b59cb8bcca519a4e59efa1c78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30733675827-db09271/ghosttykit_0.5.1-dev-30733675827-db09271_linux_arm64.zip"
      sha256 "80f430d3b1f5139795dd8a97d10b4b919fbff792d88f5365ce319e01a81a539d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.5.1-dev-30733675827-db09271/ghosttykit_0.5.1-dev-30733675827-db09271_linux_amd64.zip"
      sha256 "2b3ba91ef1576b99b79076f8f9daaf84d8900dba68d84db1211f1ffb7d3b4e91"
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
    assert_match "gty 0.5.1-dev-30733675827-db09271 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.5.1-dev-30733675827-db09271", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

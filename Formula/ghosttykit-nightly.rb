class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.7.2-dev-39785195102-ddfab0d"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39785195102-ddfab0d/ghosttykit_0.7.2-dev-39785195102-ddfab0d_darwin_arm64.zip"
      sha256 "513dfa07b2b161f821fc908e843a4e3aaece02385df6ecaa285a9d683fc21a4a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39785195102-ddfab0d/ghosttykit_0.7.2-dev-39785195102-ddfab0d_linux_arm64.zip"
      sha256 "7d83fc28f03b33ddbc1785ece11998f03c717e526c9a53caf153396f87911497"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.7.2-dev-39785195102-ddfab0d/ghosttykit_0.7.2-dev-39785195102-ddfab0d_linux_amd64.zip"
      sha256 "139a34557d3e9523de0e4d7eab13a01f92ba43a033c0a90a4e7a1d066cd44ca7"
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
    assert_match "gty 0.7.2-dev-39785195102-ddfab0d protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.7.2-dev-39785195102-ddfab0d", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

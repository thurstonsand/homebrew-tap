class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.8.3-dev-45869495688-da371d3"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45869495688-da371d3/ghosttykit_0.8.3-dev-45869495688-da371d3_darwin_arm64.zip"
      sha256 "1dff1c756ed548868a8431aaa699e8cb2f4ebbafc9fd752651496f2d32360508"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45869495688-da371d3/ghosttykit_0.8.3-dev-45869495688-da371d3_linux_arm64.zip"
      sha256 "45d51faaa426be195f7545971f4ae6aeb5f73cd6cd04299fc50ae70ec24956c7"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.8.3-dev-45869495688-da371d3/ghosttykit_0.8.3-dev-45869495688-da371d3_linux_amd64.zip"
      sha256 "7b0504c11a1249e06f1949925cf233ca21a54e5259d82cd91f570f43253eb0f2"
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
    assert_match "gty 0.8.3-dev-45869495688-da371d3 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.8.3-dev-45869495688-da371d3", shell_output("#{bin}/ghosttykitd --version") if OS.mac?
  end
end

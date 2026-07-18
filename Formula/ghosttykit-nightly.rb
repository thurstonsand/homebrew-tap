class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-29641340442-6f6de24"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29641340442-6f6de24/ghosttykit_0.4.0-dev-29641340442-6f6de24_darwin_arm64.zip"
      sha256 "6c9936e0f7a18e3cc0f2fd630576e38fb5d74efb657e317b0aefed025ca0558a"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29641340442-6f6de24/ghosttykit_0.4.0-dev-29641340442-6f6de24_darwin_amd64.zip"
      sha256 "a56cf8882ba2a230a391e30113d1c7581003411d375b5b7d846f80b0eca01397"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty and ghosttykitd"

  def install
    bin.install "bin/gty"
    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    <<~EOS
      This formula tracks nightly builds from GhosttyKit main and may break.

      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.4.0-dev-29641340442-6f6de24 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-29641340442-6f6de24", shell_output("#{bin}/ghosttykitd --version")
  end
end

# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.3.1-nightly-40529951122-8f3bc8f"
  sha256 "e88be8cae71a35ee789ea09a2edddb9d2284ac49f046be6e77f9dfb6a1e73250"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.3.1-nightly-40529951122-8f3bc8f/MiniWhisper_0.3.1-nightly-40529951122-8f3bc8f_darwin_arm64.zip"
  name "MiniWhisper Nightly"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    skip "Nightly builds are published from main."
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "MiniWhisper Nightly.app"

  # This also removes the downloaded speech model.
  zap trash: [
    "~/Library/Application Support/MiniWhisper Nightly",
    "~/Library/Caches/com.thurstonsand.MiniWhisper.nightly",
    "~/Library/HTTPStorages/com.thurstonsand.MiniWhisper.nightly",
    "~/Library/Preferences/com.thurstonsand.MiniWhisper.nightly.plist",
  ]
end

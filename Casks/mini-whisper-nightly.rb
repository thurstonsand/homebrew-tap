# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.5.2-nightly-45530514292-9280733"
  sha256 "c385e9bcbdf982897a9e311d910b752595a419e8d446473d105d738e0d4716e8"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-#{version}/MiniWhisper_#{version}_darwin_arm64.zip"
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

# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.4.1-nightly-44996895996-5b8f2da"
  sha256 "7639a7a2f344d1b2ae4648ee999621e70f82a6611c08d22045169014a3e09f94"

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

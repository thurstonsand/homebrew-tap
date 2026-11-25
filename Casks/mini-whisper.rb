# typed: strict
# frozen_string_literal: true

cask "mini-whisper" do
  version "0.5.1"
  sha256 "160da074d4b9a1f0f3a2c939c96bd888cc403cdb5eb3982596b25e666efc910e"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/v#{version}/MiniWhisper_#{version}_darwin_arm64.zip"
  name "MiniWhisper"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "MiniWhisper.app"

  # This also removes the downloaded speech model.
  zap trash: [
    "~/Library/Application Support/MiniWhisper",
    "~/Library/Caches/com.thurstonsand.MiniWhisper",
    "~/Library/HTTPStorages/com.thurstonsand.MiniWhisper",
    "~/Library/Preferences/com.thurstonsand.MiniWhisper.plist",
  ]
end

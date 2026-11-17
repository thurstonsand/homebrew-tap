# typed: strict
# frozen_string_literal: true

cask "mini-whisper" do
  version "0.4.0"
  sha256 "18d369469ebfa7c52a96994cd31ee4436637f3a6462d3c7843e87d8692c7892a"

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

# typed: strict
# frozen_string_literal: true

cask "mini-whisper" do
  version "0.2.0"
  sha256 "605d59ffafc0aaf7a3725adde0613b5099efbea7896f8f9479144fa0277479ca"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/v0.2.0/MiniWhisper_0.2.0_darwin_arm64.zip"
  name "MiniWhisper"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  conflicts_with cask: "mini-whisper-nightly"
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MiniWhisper.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper"
end

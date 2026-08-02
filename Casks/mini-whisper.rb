# typed: strict
# frozen_string_literal: true

cask "mini-whisper" do
  version "0.1.0"
  sha256 "e0b2d7c26f765b69effde7673a682bfd846cb4fe09f3a059deafbbc091caf637"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/v0.1.0/MiniWhisper_0.1.0_darwin_arm64.zip"
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

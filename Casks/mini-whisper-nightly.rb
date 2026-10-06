# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-37482958972-b951c75"
  sha256 "8cf33ca8f0318c6333ecd19d611574b30dcb8e17d19de7c81d7d1199932e2230"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-37482958972-b951c75/MiniWhisper_0.2.1-nightly-37482958972-b951c75_darwin_arm64.zip"
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
  zap trash: "~/Library/Application Support/MiniWhisper Nightly"
end

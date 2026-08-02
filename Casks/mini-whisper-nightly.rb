# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30736154598-2629a93"
  sha256 "eddcbf9dbe3b4fcad4635d819f5c29122c3b7882c683323dd210fd1ffeecd33e"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30736154598-2629a93/MiniWhisper_0.1.1-dev-30736154598-2629a93_darwin_arm64.zip"
  name "MiniWhisper"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    skip "Nightly builds are published from main."
  end

  conflicts_with cask: "mini-whisper"
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MiniWhisper.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper"
end

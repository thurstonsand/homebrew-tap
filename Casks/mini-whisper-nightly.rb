# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-32097111728-5c5326c"
  sha256 "6c48438a71c90c2259dd1eae83dbc7705f0333d00b55d0a39d6650a35fe8d639"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-32097111728-5c5326c/MiniWhisper_0.2.1-nightly-32097111728-5c5326c_darwin_arm64.zip"
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

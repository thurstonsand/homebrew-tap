# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-32446629343-af6aed3"
  sha256 "71375d10d02fdc0f3ce34ce75860770cb5a3fd4eb2d982badc8d0fdf36720e4d"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-32446629343-af6aed3/MiniWhisper_0.2.1-nightly-32446629343-af6aed3_darwin_arm64.zip"
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

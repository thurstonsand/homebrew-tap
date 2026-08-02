# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30756304241-80168f7"
  sha256 "5d99eb564e63c92b4c1366dc5b1f3280e3f987560f91a9d029ad5bced6788262"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30756304241-80168f7/MiniWhisper_0.1.1-dev-30756304241-80168f7_darwin_arm64.zip"
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

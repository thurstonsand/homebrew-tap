# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-31395357574-8ad1123"
  sha256 "15c6ebc40c99e2f4e848594add692c8f7c24e3a225dc411e382b561d6ef5562a"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-31395357574-8ad1123/MiniWhisper_0.2.1-nightly-31395357574-8ad1123_darwin_arm64.zip"
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

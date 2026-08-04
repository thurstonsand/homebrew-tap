# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.2.1-nightly-30936238339-ad5526b"
  sha256 "b0e79b3308260a2736eaaad1b4c570ab9be7fa1cd1264993d2e626abfeca82e1"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.2.1-nightly-30936238339-ad5526b/MiniWhisper_0.2.1-nightly-30936238339-ad5526b_darwin_arm64.zip"
  name "MiniWhisper Nightly"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  livecheck do
    skip "Nightly builds are published from main."
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MiniWhisper Nightly.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper Nightly"
end

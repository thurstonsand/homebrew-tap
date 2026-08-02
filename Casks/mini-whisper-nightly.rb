# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30756304241-80168f7"
  sha256 "a9403692b8af3a149f9fd0595b514f3e1560e3324db55d2f895bd8a79f11e8b1"

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

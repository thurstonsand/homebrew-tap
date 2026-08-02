# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30737497895-e992686"
  sha256 "1ac8ecbe8c11c60b01e32c5f78b0863a30383bd15855c4f9eb8a7010a51e6447"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30737497895-e992686/MiniWhisper_0.1.1-dev-30737497895-e992686_darwin_arm64.zip"
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

# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30788133423-954a829"
  sha256 "ba2846d33cdfc258cbf3ad28706dbb9c85004f501d3a3b1f1f9f475f7c83806a"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30788133423-954a829/MiniWhisper_0.1.1-dev-30788133423-954a829_darwin_arm64.zip"
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

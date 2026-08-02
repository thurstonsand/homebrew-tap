# typed: strict
# frozen_string_literal: true

cask "mini-whisper-nightly" do
  version "0.1.1-dev-30736776450-d3f74e2"
  sha256 "3176b7eb0bcc0b2f2db3d3ada67ba1df31f69b8acccaad2e920983a20ca25130"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/nightly-0.1.1-dev-30736776450-d3f74e2/MiniWhisper_0.1.1-dev-30736776450-d3f74e2_darwin_arm64.zip"
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

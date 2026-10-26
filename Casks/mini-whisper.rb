# typed: strict
# frozen_string_literal: true

cask "mini-whisper" do
  version "0.3.0"
  sha256 "79ed0bd5b9f79727c34464b79ac4c3f3e3671d5b3563bec02a0f62f16eced9e2"

  url "https://github.com/thurstonsand/mini-whisper/releases/download/v0.3.0/MiniWhisper_0.3.0_darwin_arm64.zip"
  name "MiniWhisper"
  desc "Local speech-to-text dictation"
  homepage "https://github.com/thurstonsand/mini-whisper"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "MiniWhisper.app"

  # This also removes the downloaded speech model.
  zap trash: "~/Library/Application Support/MiniWhisper"
end

class PwaController < ApplicationController
  def manifest
    render partial: 'pwa/manifest.json'
  end
end

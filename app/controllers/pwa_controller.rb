class PwaController < ApplicationController
  def manifest
    respond_to do |format|
      format.json render partial: 'pwa/manifest.json'
    end
  end
end

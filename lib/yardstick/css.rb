require 'yardstick/css_asset'

module Yardstick
  PRECOMPRESS_ROOT = 'tmp/yardstick/css'

  class Css

    attr_accessor :measurements

    def initialize(targets)
      @targets = targets
      precompile
      measure
    end

    private

    def measure
      @measurements = @targets.map {|t| Yardstick::CssAsset.new(t).data}
    end

    def precompile
      _ = ActionView::Base

      config = Rails.application.config
      config.assets.css_compressor = nil
      config.assets.compress       = false
      config.assets.debug          = true
      config.assets.digest         = false
      config.sass.style            = :expanded

      Sprockets::StaticCompiler.new(
        Rails.application.assets,
        File.join(Rails.root, Yardstick::PRECOMPRESS_ROOT),
        @targets,
        :digest => config.assets.digest,
        :manifest => false
      ).compile
    end

  end
end

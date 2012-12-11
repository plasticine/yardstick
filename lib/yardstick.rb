module Yardstick
  require 'yardstick/css'
  require 'yardstick/js'
  require "yardstick/railtie" if defined?(Rails)

  PRECOMPILE_ROOT =

  class Yardstick
    def initialize(options = {})
      @options = defaults.merge! options
      precompile
      measure
    end

  private

    def defaults
      {
        files: [],
        precompile_root: 'tmp/yardstick/assets'
      }
    end

    def measure
      @options.files.map {|file|
        Yardstick::JS.new file if file.include? '.js'
        Yardstick::CSS.new file if file.include? '.css'
      }.each {|file| file.measure }
    end

    def precompile
      _ = ActionView::Base

      config = Rails.application.config
      config.assets.css_compressor = nil
      config.assets.compress       = false
      config.assets.debug          = false
      config.assets.digest         = false
      config.sass.style            = :expanded

      Sprockets::StaticCompiler.new(
        Rails.application.assets,
        File.join(Rails.root, Yardstick::PRECOMPILE_ROOT),
        @files,
        :digest => config.assets.digest,
        :manifest => false
      ).compile
    end
  end
end

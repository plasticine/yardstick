require 'yardstick'
require 'rails'

module Yardstick
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir.glob(File.expand_path("../../tasks/*.rake", __FILE__)).each do |f|
        load f
      end
    end
  end
end

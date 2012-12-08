require 'yardstick'
require 'rails'
module Yardstick
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'path/to/rake.task'
    end
  end
end

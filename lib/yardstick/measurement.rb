module Yardstick
  class Measurement
    attr_accessor :measurements

    def initialize(file)
      @file = file
      @file_path = File.join(Rails.root, Yardstick::PRECOMPRESS_ROOT, @file)
      @measurements = {}
    end
  end
end

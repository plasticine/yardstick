require 'yardstick/measurement'

module Yardstick
  class Js < Yardstick::Measurement
    def measure
      file_stats
    end

    private

    def file_stats
      @data[:bytes], @data[:lines] = *`wc -cl #{@file_path} | awk {'print $2" "$1'}`.split(' ')
    end
  end
end

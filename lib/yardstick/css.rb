require 'css_parser'
require 'yardstick/measurement'

module Yardstick
  class Css < Yardstick::Measurement
    include CssParser

    def measure
      @parser = CssParser::Parser.new
      @parser.load_uri! @file_path
      file_stats
      rules
      selectors
      specificity
    end

    private

    def file_stats
      @data[:bytes], @data[:lines] = *`wc -cl #{@file_path} | awk {'print $2" "$1'}`.split(' ')
    end

    def selectors
      @parser.each_selector {@data[:selectors] += 1}
    end

    def rules
      @parser.each_rule_set {@data[:rules] += 1}
    end

    def specificity
      @parser.each_selector do |sel, dec, spec|
        @data[:specificity].merge!(Hash[[:id, :class, :element].zip(
          spec.to_s.rjust(3, '0').chars.to_a)]){|k,a,b| a.to_i + b.to_i}
      end
    end
  end
end

require 'css_parser'
include CssParser

module Yardstick
  class CssAsset

    attr_accessor :data

    def initialize(file)
      @file = file
      @file_path = File.join(Rails.root, Yardstick::PRECOMPRESS_ROOT, @file)
      @parser = CssParser::Parser.new
      @parser.load_uri! @file_path
      @data = {file: @file, selectors: 0, rules: 0, specificity: {}}
      file_stats
      rules
      selectors
      specificity
    end

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

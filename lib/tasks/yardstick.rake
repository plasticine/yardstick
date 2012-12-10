require 'yardstick/css'
require 'yardstick/browser'
require 'librato/metrics'
require 'webmock/rspec'

LIBRATO_PREFIX  = "tc.stats"
LIBRATO_USER    = ENV["LIBRATO_USER"]
LIBRATO_KEY     = ENV["LIBRATO_KEY"]

Librato::Metrics.authenticate(LIBRATO_USER, LIBRATO_KEY)
librato_queue = Librato::Metrics::Queue.new

namespace :yardstick do

  desc "Gather CSS code quality statistics"
  task :css => ['assets:environment', 'tmp:cache:clear'] do
    WebMock.disable!
    Yardstick::Css.new(['application.css', 'author.css']).measurements.each do |m|
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.selectors"           => m[:selectors])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.rules"               => m[:rules])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.bytes"               => m[:bytes])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.lines"               => m[:lines])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.specificity.id"      => m[:specificity][:id])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.specificity.class"   => m[:specificity][:class])
      librato_queue.add("#{LIBRATO_PREFIX}.css.#{m[:file]}.specificity.element" => m[:specificity][:element])
    end
    librato_queue.submit
  end

  desc "WEOWOOEOWEOWOEOWOE"
  task :all => [:css]
end

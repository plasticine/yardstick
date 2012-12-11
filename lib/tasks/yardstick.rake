require 'librato/metrics'

LIBRATO_PREFIX  = "aerobic.code"
LIBRATO_USER    = ENV["LIBRATO_USER"]
LIBRATO_KEY     = ENV["LIBRATO_KEY"]

Librato::Metrics.authenticate(LIBRATO_USER, LIBRATO_KEY)
librato_queue = Librato::Metrics::Queue.new

namespace :yardstick do

  desc "Gather CSS code quality statistics"
  task :css => ['assets:environment', 'tmp:cache:clear'] do
    Yardstick::Css.new(['application.css']).measurements.each do |m|
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.selectors"           => m[:selectors])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.rules"               => m[:rules])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.bytes"               => m[:bytes])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.lines"               => m[:lines])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.specificity.id"      => m[:specificity][:id])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.specificity.class"   => m[:specificity][:class])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.specificity.element" => m[:specificity][:element])
      puts m
    end
    librato_queue.submit
  end

  desc "Gather JS code quality statistics"
  task :js => ['assets:environment', 'tmp:cache:clear'] do
    Yardstick::Css.new(['application.js', 'vendor.js']).measurements.each do |m|
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.bytes"               => m[:bytes])
      librato_queue.add("#{LIBRATO_PREFIX}.#{m[:file]}.lines"               => m[:lines])
      puts m
    end
    librato_queue.submit
  end

  desc "Run all the stats gathering tasks"
  task :all => [:css, :js]
end

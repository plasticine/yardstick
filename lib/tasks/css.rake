require 'yardstick/css'

namespace :yardstick do
  namespace :css do

    desc "Gather CSS code quality statistics"
    task :primary => ['assets:environment', 'tmp:cache:clear'] do
      Yardstick::Css.new ['application.css', 'author.css']


    end

  end
end

puts "loading application"

require 'logger'

class Fixnum
  def percent_of_the_time
    yield if rand(100) <= self
  end
end

module ExampleTrodProject

  extend self

  def root
    @root ||= Pathname.new File.expand_path('../..', __FILE__)
  end

  def logger
    @logger ||= begin
      root.join('log').mkpath
      Logger.new(root.join('log/app.log'))
    end
  end

  def sleep_and_log_for n
    n.to_i.times do
      logger.info "sleeping for 1 second"
      sleep 1
    end
  end

end

# simulate a slow app starting
# 5.times{
#   print '.'
#   sleep 1
# }
# print "\n"

#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../../lib/example_trod_project', __FILE__)
require File.expand_path('../../spec/spec_helper', __FILE__)
LOGFILE_PATH = File.expand_path('../../log/rspec.log', __FILE__)

require 'ruby-debug'
require 'rspec'
require 'rspec/core'
require 'redis'



def run_spec spec
  args = [spec]
  args.unshift *%w{--format d}
  args.unshift *%w{--out log/rspec.log}
  p args

  puts "running: #{spec}:"

  pid = fork{
    ARGV.replace(args)
    STDOUT.reopen(LOGFILE_PATH)
    STDERR.reopen(LOGFILE_PATH)
    RSpec::Core::Runner.autorun
    # TODO find test and check its name and result
  }

  Process.wait(pid)
  puts "DONE: #{$?.success? ? 'PASS' : 'FAIL'}\n"
end



loop do
  if spec = Redis.current.lpop(:specs)
    run_spec(spec)
  end
  puts "sleeping"
  sleep 1
end

# run_spec 'spec/a_spec.rb'
# run_spec 'spec/b_spec.rb'

# run_spec 'spec/failing_spec.rb'

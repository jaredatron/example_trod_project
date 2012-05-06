#!/usr/bin/env ruby

require File.expand_path('../../lib/example_trod_project', __FILE__)
LOGFILE_PATH = File.expand_path('../../log/cucumber.log', __FILE__)

require 'ruby-debug'
require 'cucumber'
require 'redis'

def run_scenario scenario
  args = ['--name', %{^#{scenario}$}]
  # args.unshift *%w{--out log/cucumber.log}
  puts "running: #{scenario}:"

  pid = fork{
    STDOUT.reopen(LOGFILE_PATH)
    STDERR.reopen(LOGFILE_PATH)

    runtime = ::Cucumber::Runtime.new
    main = ::Cucumber::Cli::Main.new(args, $stdout, $sterr)
    main.execute!(runtime)
    if runtime.results.scenarios.size == 0
      warn "unable to find scenario"
      exit 1
    end
    if runtime.results.scenarios.size > 1
      warn "more then expected was run"
      exit 1
    end
    unless runtime.results.scenarios.first.name == scenario
      warn "wrong scenario was run"
      exit 1
    end
    exit(1) unless runtime.results.scenarios.first.passed?
  }

  Process.wait(pid)
  puts "DONE: #{$?.success? ? 'PASS' : 'FAIL'}\n"
end

puts "waiting for scenarios..."
loop do
  if scenario = Redis.current.lpop(:scenarios)
    run_scenario(scenario)
    next
  end
  sleep 1
end

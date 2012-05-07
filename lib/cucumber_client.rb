#!/usr/bin/env ruby -w
# simple_client.rb
# A simple DRb client

require 'drb'
require 'irb'

DRb.start_service

# attach to the DRb server via a URI given on the command line
CUCUMBER_SERVER = DRbObject.new_with_uri('druby://localhost:51555')

def run_scenario *args
  CUCUMBER_SERVER.run_scenario(*args)
end

IRB.start

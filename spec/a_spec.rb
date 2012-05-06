require 'spec_helper'

describe 'A' do

  it "should take 1 second to test" do
    ExampleTrodProject.sleep_and_log_for 1
  end

end

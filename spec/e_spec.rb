require 'spec_helper'

describe 'E' do

  it "should take 2 second to test" do
    ExampleTrodProject.sleep_and_log_for 2
  end

end

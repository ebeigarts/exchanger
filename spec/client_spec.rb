require "spec_helper"

describe Exchanger::Client do
  before do
    @client = Exchanger::Client.new
  end

  it "should respond to #request" do
    @client.should respond_to(:request)
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::GetRoomLists do

  before do
    @response = VCR.use_cassette('get_room_lists') do
      Exchanger::GetRoomLists.run(@valid_attributes)
    end
    @items = @response.items
  end

  it "should be sucessfull with default values" do
    VCR.use_cassette('get_room_lists_default') do
      Exchanger::GetRoomLists.run().status.should == 200
    end
  end

  it "should be sucessfull with valid data" do
    @response.status.should == 200
  end

  it "should response have Room items" do
    @items.all?{ |i| i.class.name == "Exchanger::Room" }.should be_true
  end

end

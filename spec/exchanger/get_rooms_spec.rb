require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::GetRooms do

  before do
    @response = VCR.use_cassette('get_rooms') do
      Exchanger::GetRoomLists.run(@valid_attributes)
    end
    @items = @response.items
  end

  it "should be sucessfull with the first room list mail" do
    VCR.use_cassette('get_rooms_default') do
      rooms = Exchanger::GetRoomLists.run.items
      Exchanger::GetRooms.run(rooms.first.email_address).status.should == 200
    end
  end

  it "should be sucessfull with valid data" do
    @response.status.should == 200
  end

  it "should response have Room items" do
    @items.all?{ |i| i.class.name == "Exchanger::Room" }.should be_true
  end

end

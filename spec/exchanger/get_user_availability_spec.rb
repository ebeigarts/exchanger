require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::GetUserAvailability do
  before(:all) do
    @valid_attributes = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../fixtures/get_user_availability.yml'))
    @valid_attributes["start_time"] = Time.parse(@valid_attributes["start_time"])
    @valid_attributes["end_time"] = Time.parse(@valid_attributes["end_time"])
  end

  before do
    @response = VCR.use_cassette('get_user_availability') do
      Exchanger::GetUserAvailability.run(@valid_attributes)
    end
    @items = @response.items
  end

  it "should be sucessfull with default values" do
    VCR.use_cassette('get_user_availability_default') do
      Exchanger::GetUserAvailability.run().status.should == 200
    end
  end

  it "should be sucessfull with valid data" do
    @response.status.should == 200
  end

  it "should response have calendar event items" do
    @items.all?{ |i| i.class.name == "Exchanger::CalendarEvent" }.should be_true
  end

  it "should calendar event item have valid attributes" do
    ["start_time", "end_time", "busy_type", "calendar_event_details"].each do |k|
      @items[0].attributes.keys.include?(k).should be_true
    end
  end

  it "should calendar event items have calendar event details" do
    @items.all?{ |i| i.calendar_event_details.class.name == "Exchanger::CalendarEventDetails" }.should be_true
  end

  it "should calendar event details item have valid attributes" do
    ["id","subject","location", "is_meeting", "is_recurring", "is_exception", "is_reminder_set", "is_private"].each do |k|
      @items[0].calendar_event_details.attributes.keys.include?(k).should be_true
    end
  end
end

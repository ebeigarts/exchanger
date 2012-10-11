require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::CalendarFolder do
  before do
    @folder = VCR.use_cassette('folder/find_calendar') do
      Exchanger::Folder.find(:calendar)
    end
  end

  it "should return calendar folder" do
    @folder.class.should == Exchanger::CalendarFolder
  end
end

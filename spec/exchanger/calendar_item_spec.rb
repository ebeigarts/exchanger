require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::CalendarItem do
  before do
    @folder = VCR.use_cassette('folder/find_calendar') do
      Exchanger::Folder.find(:calendar)
    end
  end

  describe ".find" do
    it "should find by id"
  end
end

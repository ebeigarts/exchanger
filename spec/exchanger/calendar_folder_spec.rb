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

  describe "#user_configuration" do
    it "should read the calendar's category list" do
      VCR.use_cassette("folder/get_user_configuration") do
        # Assumes that the default "Blue category" hasn't been deleted from the calendar
        blue_category = @folder.category_list.detect { |category| category.color == 7 }
        blue_category.category_color.css_color.should == "rgb(85, 171, 229)"
      end
    end
  end
end

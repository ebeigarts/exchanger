require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::CalendarItem do
  before do
    @folder = VCR.use_cassette('folder/find_calendar') do
      Exchanger::Folder.find(:calendar)
    end
    @calendar_item = @folder.new_calendar_item
  end

  describe "#save" do
    after do
      if @calendar_item.persisted?
        VCR.use_cassette("calendar_item/save_cleanup") do
          @calendar_item.destroy
        end
      end
    end

    it "should create and update calendar item" do
      VCR.use_cassette("calendar_item/save") do
        prev_items_size = @folder.items.size
        @calendar_item.subject = "Calendar Item Subject"
        @calendar_item.body = Exchanger::Body.new(text: "Body line 1.\nBody line 2.")
        @calendar_item.start = Time.now
        @calendar_item.end = Time.now + 30.minutes
        @calendar_item.should be_changed
        @calendar_item.save
        @calendar_item.should_not be_new_record
        @calendar_item.should_not be_changed
        @calendar_item.reload
        @calendar_item.subject.should == "Calendar Item Subject"
        @folder.items.size.should == prev_items_size + 1
      end
    end
  end
end

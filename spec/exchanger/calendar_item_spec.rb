require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

SUBJECT = "Test Calendar Item"

describe Exchanger::CalendarItem do
  before do
    @folder = VCR.use_cassette('folder/find_calendar') do
      Exchanger::Folder.find(:calendar)
    end
    @calendar_item = @folder.new_calendar_item(subject: SUBJECT,
                                                  body: Exchanger::Body.new(text: "Body line 1.\nBody line 2."),
                                                  start: Time.now,
                                                    end: Time.now + 30.minutes,
                                             categories: [Exchanger::CategoryString.new(text: "Green category")])
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
        @calendar_item.should be_changed
        @calendar_item.save
        @calendar_item.should_not be_new_record
        @calendar_item.should_not be_changed
        @calendar_item.reload
        @calendar_item.subject.should == SUBJECT
        @calendar_item.categories.should == ["Green category"]
        puts "woot"
        puts "item itslef"
        puts @calendar_item.inspect
        puts "Parent folder categories"
        puts @calendar_item.parent_folder.category_list.inspect
        puts "Categories"
        puts @calendar_item.categories.inspect

        # FIXME Implementation is language dependat since it used the name of the color category
        # @calendar_item.categories_with_color.map { |c| c.category_color.css_color }.should == ["rgb(95, 190, 125)"]
        
        @folder.items.size.should == prev_items_size + 1
        @calendar_item.subject += " Updated"
        @calendar_item.should be_changed
        @calendar_item.save
        @calendar_item.should_not be_changed
      end
    end
  end

  describe "#file_attachment" do
    after do
      if @calendar_item.persisted?
        VCR.use_cassette("calendar_item/save_file_attachment_cleanup") do
          @calendar_item.destroy
        end
      end
    end

    it "should create and read file attachments" do
      VCR.use_cassette("calendar_item/save_file_attachment") do
        @calendar_item.save

        content = "Test Content"
        file_attachment = @calendar_item.new_file_attachment(name: "test.txt", content_type: "text/plain", content: content)
        file_attachment.save

        @calendar_item.reload  # Pull attachment metadata using GetItem
        @calendar_item.attachments.size.should == 1

        attachment = Exchanger::Attachment.find(@calendar_item.attachments[0].id)  # Pull attachment content using GetAttachment
        attachment.content.should == content

        attachment.destroy
      end
    end
  end
end

require "spec/spec_helper"

describe Exchanger::CalendarFolder do
  before do
    @folder = Exchanger::Folder.find(:calendar)
  end

  it "should return calendar folder" do
    @folder.class.should == Exchanger::CalendarFolder
  end

  it "should have calendar items" do
    @folder.items.size.should > 0
  end
end

describe Exchanger::CalendarItem do
  before do
    @folder = Exchanger::Folder.find(:calendar)
    @item = @folder.items.first
  end

  it "should have start time" do
    @item.start.class.should == Time
  end
end

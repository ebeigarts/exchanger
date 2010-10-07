require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Exchanger::Mailbox do
  it "should resolve names for distribution list and show members" do
    @mailboxes = Exchanger::Mailbox.search("DL")
    @mailboxes.size.should > 0
    @mailboxes[0].members.size.should > 0
  end
end

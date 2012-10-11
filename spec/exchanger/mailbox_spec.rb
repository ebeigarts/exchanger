require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::Mailbox do
  describe ".search" do
    it "should resolve names for distribution list and show members" do
      @mailboxes = VCR.use_cassette('mailbox/search_test') do
        Exchanger::Mailbox.search("test")
      end
      if @mailboxes.size == 0
        pending "Please create distribution list named 'Test' with one member"
      end
      @mailboxes.size.should be > 0
      VCR.use_cassette('mailbox/search_test_members') do
        @mailboxes[0].members.size.should be > 0
      end
    end
  end
end

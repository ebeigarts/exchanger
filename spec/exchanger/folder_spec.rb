require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::Folder do
  before do
    @folder = VCR.use_cassette('folder/find_root') do
      Exchanger::Folder.find(:root)
    end
  end

  describe "#folders" do
    it "should return sub folders" do
      VCR.use_cassette('folder/find_root_folders') do
        @folder.folders.size.should > 0
      end
    end
  end
end

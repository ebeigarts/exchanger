require "spec_helper"

describe Exchanger::Folder do
  describe "Root" do
    before do
      @folder = Exchanger::Folder.find(:root)
    end

    it "should have sub folders" do
      @folder.folders.size.should > 0
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exchanger::Contact do
  before do
    @folder = VCR.use_cassette('folder/find_contacts') do
      Exchanger::Folder.find(:contacts)
    end
    @contact = Exchanger::Contact.new
    @contact.parent_folder_id = @folder.folder_id
  end

  describe "#save" do
    after do
      if @contact.persisted?
        VCR.use_cassette("contact/save_cleanup") do
          @contact.destroy
        end
      end
    end

    it "should create and update contact" do
      VCR.use_cassette("contact/save") do
        prev_items_size = @folder.items.size
        @contact.given_name = "Edgars"
        @contact.surname = "Beigarts"
        @contact.nickname = "EBEI"
        @contact.complete_name = \
          Exchanger::CompleteName.new(:first_name => "Edgars", :last_name => "Beigarts") # read only
        @contact.physical_addresses = [
          Exchanger::PhysicalAddress.new(:key => "Business", :city => "Riga", :street => "Brivibas iela 1", :state => ""),
          Exchanger::PhysicalAddress.new(:key => "Home", :city => "Riga", :street => "Brivibas iela 2")
        ]
        @contact.email_addresses = [
          Exchanger::EmailAddress.new(:key => "EmailAddress1", :text => "edgars.beigarts@tieto.com")
        ]
        @contact.should be_changed
        @contact.save
        @contact.should_not be_new_record
        @contact.should_not be_changed
        @contact.reload
        @contact.nickname.should == "EBEI"
        @contact.physical_addresses.size.should == 2
        @contact.physical_addresses[0].key.should == "Business"
        @contact.physical_addresses[0].city.should == "Riga"
        @contact.physical_addresses[1].key.should == "Home"
        @contact.physical_addresses[1].city.should == "Riga"
        @contact.email_addresses.size.should == 1
        @contact.email_addresses[0].key.should == "EmailAddress1"
        @contact.email_addresses[0].text.should == "edgars.beigarts@tieto.com"
        @folder.items.size.should == prev_items_size + 1
        @contact.nickname = "Test"
        @contact.physical_addresses.pop # delete last address
        @contact.should be_changed
        @contact.save
        @contact.should_not be_changed
        @contact.physical_addresses.size.should == 1
      end
    end

    it "cannot create a contact without a parent_folder" do
      @contact.parent_folder_id = nil
      @contact.save.should be_falsey
      @contact.errors.should include("Parent folder can't be blank")
    end
  end

  describe "#destroy" do
    before do
      VCR.use_cassette("contact/destroy_setup") do
        @contact.save
      end
    end

    it "should destroy contact and return true" do
      VCR.use_cassette("contact/destroy") do
        @contact.destroy.should be_truthy
      end
    end
  end

  describe ".find" do
    before do
      VCR.use_cassette("contact/find_setup") do
        @contact.save
      end
    end

    it "should find a contact by id" do
      VCR.use_cassette("contact/find") do
        found_contact = Exchanger::Contact.find(@contact.id)
        found_contact.id.should == @contact.id
      end
    end

    it "should have parent folder" do
      VCR.use_cassette("contact/find") do
        found_contact = Exchanger::Item.find(@contact.id)
        found_contact.parent_folder.id.should == @folder.id
      end
    end
  end
end

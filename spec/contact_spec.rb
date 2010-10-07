require "spec/spec_helper"

describe Exchanger::Contact do
  before do
    @folder = Exchanger::Folder.find(:contacts, "edgars.beigarts@tieto.com")
  end

  it "should return calendar folder" do
    @folder.class.should == Exchanger::ContactsFolder
  end

  it "should have contacts" do
    @folder.items.size.should > 0
  end

  it "should create a new contact and update it" do
    prev_items_size = @folder.items.size
    @contact = @folder.new_contact(:given_name => "Edgars", :surname => "Beigarts", :nickname => "EBEI")
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

  it "should find a contact by id" do
    @contact = @folder.items.first
    Exchanger::Item.find(@contact.id).should be_an_instance_of(Exchanger::Contact)
  end

  it "should have parent folder" do
    @contact = @folder.items.first
    @contact.parent_folder.should == @folder
    @contact = Exchanger::Item.find(@contact.id)
    @contact.parent_folder.should == @folder
  end

  it "cannot create a contact without a parent_folder" do
    @contact = Exchanger::Contact.new
    @contact.save.should be_false
    @contact.errors.should include("Parent folder can't be blank")
  end
end

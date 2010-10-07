require "spec/spec_helper"

describe Exchanger::Field do
  describe "String (default type)" do
    before do
      @field = Exchanger::Field.new(:full_name)
      @full_name = "Edgars Beigarts"
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.FullName @full_name
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml(@full_name).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == @full_name
    end
  end

  describe "String (UID)" do
    before do
      @field = Exchanger::Field.new(:uid, :type => String, :name => "UID")
      @uid = "123"
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.UID @uid
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml(@uid).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == @uid
    end
  end

  describe "Integer" do
    before do
      @field = Exchanger::Field.new(:total_count, :type => Integer)
      @total_count = 5
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.TotalCount @total_count
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml(@total_count).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == @total_count
    end
  end

  describe "Boolean" do
    before do
      @field = Exchanger::Field.new(:is_read, :type => Exchanger::Boolean)
      @is_read = true
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.IsRead @is_read.to_s
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml(@is_read).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == @is_read
    end
  end

  describe "Time" do
    before do
      @field = Exchanger::Field.new(:date_time_sent, :type => Time)
      @date_time_sent_as_str = "2010-05-21T05:57:57Z"
      @date_time_sent = Time.utc(2010, 5, 21, 5, 57, 57)
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.DateTimeSent @date_time_sent_as_str
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml(@date_time_sent).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == @date_time_sent
    end
  end

  describe "Array of Physical Addresses" do
    before do
      @field = Exchanger::Field.new(:phone_numbers, :type => [Exchanger::PhysicalAddress])
      @address = Exchanger::PhysicalAddress.new(:street => "Brivibas str.", :city => "Riga", :state => "Latvia")
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.PhoneNumbers do
          xml.Entry do
            xml.Street @address.street
            xml.City @address.city
            xml.State @address.state
          end
        end
      end.doc.root
    end

    it "should convert value to XML" do
      @field.to_xml([@address]).to_s.gsub(/\n\s*/, "").should == @xml.to_s.gsub(/\n\s*/, "")
    end

    it "should convert XML to value" do
      @field.value_from_xml(@xml).should == [@address]
    end
  end
end

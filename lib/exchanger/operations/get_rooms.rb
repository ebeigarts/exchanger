module Exchanger
  # GetRooms operation
  # 
  # http://msdn.microsoft.com/en-us/library/dd899415(v=exchg.150).aspx

  class GetRooms < Operation
    class Request < Operation::Request
      attr_accessor :room_list_mail

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
           xml.send("soap:Envelope", "xmlns:xsi" => NS["xsi"],
                    "xmlns:xsd" => NS["xsd"], "xmlns:soap" => NS["soap"],
                    "xmlns:t" => NS["t"], "xmlns:m" => NS["m"]) do
             xml.send("soap:Header") do
               xml.send("t:RequestServerVersion", "Version" => 'Exchange2010_SP1') 
             end
             xml.send("soap:Body") do
               xml.send("m:GetRooms") do
                 xml.send("m:RoomList") do
                   xml.send("t:EmailAddress", room_list_mail)
                 end
               end
             end
           end
        end
      end
    end

    class Response < Operation::Response
      def items
        to_xml.xpath(".//m:Rooms", NS).children.map do |node|
          item_klass = Exchanger.const_get(node.name)
          item_klass.new_from_xml(node.child)
        end
      end
    end

  end

end

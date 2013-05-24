module Exchanger
  # GetRoomLists operation
  # 
  # http://msdn.microsoft.com/en-us/library/dd899416(v=exchg.150).aspx

  class GetRoomLists < Operation
    class Request < Operation::Request
      def to_xml
        Nokogiri::XML::Builder.new do |xml|
           xml.send("soap:Envelope", "xmlns:xsi" => NS["xsi"],
                    "xmlns:xsd" => NS["xsd"], "xmlns:soap" => NS["soap"],
                    "xmlns:t" => NS["t"], "xmlns:m" => NS["m"]) do
             xml.send("soap:Header") do
               xml.send("t:RequestServerVersion", "Version" => 'Exchange2010_SP1')
             end
             xml.send("soap:Body") do
               xml.send("m:GetRoomLists")
             end
           end
        end
      end
    end   
          
    class Response < Operation::Response
      def items
        to_xml.xpath(".//m:RoomLists", NS).children.map do |node|
          item_klass = Exchanger.const_get(node.name)
          item_klass.new_from_xml(node)
        end
      end
    end
  
  end               

end

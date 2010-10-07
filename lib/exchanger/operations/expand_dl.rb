module Exchanger
  # The ExpandDL operation exposes the full membership of distribution lists.
  # 
  # http://msdn.microsoft.com/en-us/library/aa494152.aspx
  class ExpandDL < Operation
    class Request < Operation::Request
      attr_accessor :mailbox

      # Reset request options to defaults.
      def reset
        @mailbox = nil
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"]) do
            xml.send("soap:Body") do
              xml.ExpandDL("xmlns" => NS["m"], "xmlns:t" => NS["t"]) do
                xml.Mailbox do
                  if mailbox.item_id
                    xml.send("t:ItemId", "Id" => mailbox.item_id.id, "ChangeKey" => mailbox.item_id.change_key)
                  else
                    xml.send("t:EmailAddress", mailbox.email_address)
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def mailboxes
        to_xml.xpath(".//t:Mailbox", NS).map do |node|
          item_klass = Exchanger.const_get(node.name)
          item_klass.new_from_xml(node)
        end
      end
    end
  end
end

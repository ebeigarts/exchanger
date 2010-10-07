module Exchanger
  # The GetFolder operation gets folders from the Exchanger store.
  # 
  # http://msdn.microsoft.com/en-us/library/aa580274.aspx
  class GetFolder < Operation
    class Request < Operation::Request
      attr_accessor :folder_ids, :base_shape, :email_address

      # Reset request options to defaults.
      def reset
        @folder_ids = []
        @base_shape = :default
        @email_address = nil
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"]) do
            xml.send("soap:Body") do
              xml.GetFolder("xmlns" => NS["m"], "xmlns:t" => NS["t"]) do
                xml.FolderShape do
                  xml.send "t:BaseShape", base_shape.to_s.camelize
                end
                xml.FolderIds do
                  folder_ids.each do |folder_id|
                    if folder_id.is_a?(Symbol)
                      xml.send("t:DistinguishedFolderId", "Id" => folder_id) do
                        if email_address
                          xml.send("t:Mailbox") do
                            xml.send("t:EmailAddress", email_address)
                          end
                        end
                      end
                    else
                      xml.send("t:FolderId", "Id" => folder_id)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def folders
        to_xml.xpath(".//m:Folders", NS).children.map do |node|
          folder_klass = Exchanger.const_get(node.name)
          folder_klass.new_from_xml(node)
        end
      end
    end
  end
end

module Exchanger
  # The FindFolder operation uses Exchanger Web Services to find subfolders of 
  # an identified folder and returns a set of properties that describe the set of subfolders.
  #
  # http://msdn.microsoft.com/en-us/library/aa563918.aspx
  class FindFolder < Operation
    class Request < Operation::Request
      attr_accessor :parent_folder_id, :base_shape, :email_address, :traversal

      # Reset request options to defaults.
      def reset
        @parent_folder_id = nil
        @traversal = :shallow
        @base_shape = :all_properties
        @email_address = nil
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"]) do
            xml.send("soap:Body") do
              xml.FindFolder("xmlns" => NS["m"], "xmlns:t" => NS["t"], "Traversal" => traversal.to_s.camelize) do
                xml.FolderShape do
                  xml.send "t:BaseShape", base_shape.to_s.camelize
                end
                xml.ParentFolderIds do
                  if parent_folder_id.is_a?(Symbol)
                    xml.send("t:DistinguishedFolderId", "Id" => parent_folder_id) do
                      if email_address
                        xml.send("t:Mailbox") do
                          xml.send("t:EmailAddress", email_address)
                        end
                      end
                    end
                  else
                    xml.send("t:FolderId", "Id" => parent_folder_id)
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
        to_xml.xpath(".//t:Folders", NS).children.map do |node|
          folder_klass = Exchanger.const_get(node.name)
          folder_klass.new_from_xml(node)
        end
      end
    end
  end
end

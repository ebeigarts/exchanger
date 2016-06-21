module Exchanger
  class Attachment < Element
    self.identifier_name = :attachment_id

    element :attachment_id, type: Identifier
    element :name
    element :content_type
    element :content_id
    element :content_location
    element :size, type: Integer
    element :last_modified_time, type: Time
    element :is_inline, type: Boolean

    attr_accessor :parent_item_id

    def self.find(id)
      find_all([id]).first
    end

    def self.find_all(ids)
      response = GetAttachment.run(attachment_ids: ids)
      response.attachments
    end

    # The "Attachments" element contains the items or files that are attached to an item in the Exchange store.
    #
    #   <Attachments>
    #     <ItemAttachment/>
    #     <FileAttachment/>
    #   </Attachments>
    #
    # https://msdn.microsoft.com/en-us/library/office/aa564869(v=exchg.150).aspx
    #
    # Determine if the given XML node contains an ItemAttachment or FileAttachment and initialize the new instance.
    #
    def self.new_from_xml(xml)
      attachment_subclass = Exchanger.const_get(xml.name)
      attachment_subclass.new.assign_attributes_from_xml(xml)
    end

    private

      def create
        if parent_item_id
          response = CreateAttachment.run(parent_item_id: parent_item_id, attachments: [self])
          self.attachment_id = response.attachment_ids[0]
          move_changes
          true
        else
          errors << "Parent item can't be blank"
          false
        end
      end

      def update
        raise NotImplementedError, "There is no UpdateAttribute operation in Exchange.  Delete the attachment and recreate to update."
      end

      def delete
        DeleteAttachment.run(attachment_ids: [id]) ? true : false
      end

  end
end

module Exchanger
  class Item < Element
    self.field_uri_namespace = :item
    self.identifier_name = :item_id

    element :mime_content
    element :item_id, :type => Identifier
    element :parent_folder_id, :type => Identifier
    element :item_class
    element :subject
    element :sensitivity
    element :body, type: Body
    element :attachments, :type => [Attachment]
    element :date_time_received, :type => Time
    element :size, :type => Integer
    element :categories, :type => [CategoryString]
    element :importance
    element :in_reply_to
    element :is_submitted, :type => Boolean
    element :is_draft, :type => Boolean
    element :is_from_me, :type => Boolean
    element :is_resend, :type => Boolean
    element :is_unmodified, :type => Boolean
    element :internet_message_headers, :type => [String]
    element :date_time_sent, :type => Time
    element :date_time_created, :type => Time
    element :response_objects, :type => [String]
    element :reminder_due_by, :type => Time
    element :reminder_is_set, :type => Boolean
    element :reminder_minutes_before_start
    element :display_cc
    element :display_to
    element :has_attachments, :type => Boolean
    element :extended_property
    element :culture
    element :effective_rights
    element :last_modified_name
    element :last_modified_time, :type => Time

    def self.find(id)
      find_all([id]).first
    end

    def self.find_all(ids)
      response = GetItem.run(:item_ids => ids)
      response.items
    end

    def self.find_all_by_folder_id(folder_id, email_address = nil)
      response = FindItem.run(:folder_id => folder_id, :email_address => email_address)
      response.items
    end

    def self.find_calendar_view_set_by_folder_id(folder_id, calendar_view)
      response = FindItem.run(
        folder_id:     folder_id,
        calendar_view: calendar_view,
      )

      response.items
    end

    attr_writer :parent_folder

    def parent_folder
      @parent_folder ||= if parent_folder_id
        Folder.find(parent_folder_id.id)
      end
    end

    def new_file_attachment(attributes = {})
      FileAttachment.new(attributes.merge(parent_item_id: item_id.id))
    end

    def file_attachments
      attachments.select { |attachment| attachment.is_a?(FileAttachment) }
    end

    # TODO The 0.2.1 implementation is depended on the language of the integration. This code
    # only works if the user have selected English as their language of choice, see c.name
    def categories_with_color
      parent_folder.category_list.select { |c| categories.include?(c.name) }
    end

    private

    def create
      if parent_folder_id
        options = { folder_id: parent_folder_id.id, items: [self] }.merge(create_additional_options)
        response = CreateItem.run(options)
        self.item_id = response.item_ids[0]
        move_changes
        true
      else
        errors << "Parent folder can't be blank"
        false
      end
    end

    def create_additional_options
      {}  # Implement in subclasses to add CreateItem options
    end

    def update
      if changed?
        options = { items: [self] }.merge(update_additional_options)
        response = UpdateItem.run(options)
        move_changes
        true
      else
        true
      end
    end

    def update_additional_options
      {}  # Implement in subclasses to add UpdateItem options
    end

    def delete
      options = { item_ids: [id] }.merge(delete_additional_options)
      if DeleteItem.run(options)
        true
      else
        false
      end
    end

    def delete_additional_options
      {}  # Implement in subclasses to add DeleteItem options
    end
  end
end

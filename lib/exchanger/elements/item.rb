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
    element :body
    element :attachments, :type => [String]
    element :date_time_received, :type => Time
    element :size, :type => Integer
    element :categories, :type => [String]
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

    private

    def create
      if parent_folder_id
        response = CreateItem.run(:folder_id => parent_folder_id.id, :items => [self])
        self.item_id = response.item_ids[0]
        move_changes
        true
      else
        errors << "Parent folder can't be blank"
        false
      end
    end

    def update
      if changed?
        response = UpdateItem.run(:items => [self])
        move_changes
        true
      else
        true
      end
    end

    def delete
      if DeleteItem.run(:item_ids => [id])
        true
      else
        false
      end
    end
  end
end

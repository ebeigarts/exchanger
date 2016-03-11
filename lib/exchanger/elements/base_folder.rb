module Exchanger
  # Abstract folder class
  class BaseFolder < Element
    self.identifier_name = :folder_id
    self.field_uri_namespace = :folder

    element :folder_id, :type => Identifier
    element :parent_folder_id, :type => Identifier
    element :folder_class
    element :display_name
    element :total_count, :type => Integer
    element :child_folder_count, :type => Integer
    element :extended_property, :type => Element
    element :managed_folder_information, :type => Element
    element :effective_rights, :type => Element

    # Folders that can be referenced by name.
    # http://msdn.microsoft.com/en-us/library/aa580808.aspx
    DISTINGUISHED_NAMES = [
      :inbox, :outbox, :drafts, :deleteditems, :sentitems, :junkemail,
      :calendar, :contacts, :tasks, :notes, :journal,
      :msgfolderroot, :publicfoldersroot, :root,
      :searchfolders, :voicemail
    ]

    def self.find(id, email_address = nil)
      find_all([id], email_address).first
    end

    def self.find_all(ids, email_address = nil)
      response = GetFolder.run(:folder_ids => ids, :email_address => email_address)
      response.folders
    end

    def self.find_all_by_parent_id(parent_id)
      response = FindFolder.run(:parent_folder_id => parent_id)
      response.folders
    end

    attr_writer :parent_folder

    def parent_folder
      @parent_folder ||= if parent_folder_id
        Folder.find(parent_folder_id.id)
      end
    end

    # Sub folders
    def folders
      self.class.find_all_by_parent_id(id).each do |folder|
        folder.parent_folder = self
      end
    end

    def items
      Item.find_all_by_folder_id(id).each do |item|
        item.parent_folder = self
      end
    end

    # Return items (also recurring calendar items) based on
    # provided CalendarView options
    def items_from_calendar_view(calendar_view_options)
      calendar_view = CalendarView.new(calendar_view_options)
      items = Item.find_calendar_view_set_by_folder_id(id, calendar_view)

      items.each { |item| item.parent_folder = self }
    end
  end
end

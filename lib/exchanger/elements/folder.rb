module Exchanger
  # The Folder element defines a folder to create, get, find, synchronize, or update.
  # 
  # http://msdn.microsoft.com/en-us/library/aa494294.aspx
  class Folder < BaseFolder
    element :permission_set
    element :unread_count, :type => Integer
  end
end

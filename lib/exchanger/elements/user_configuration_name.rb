module Exchanger
  # The UserConfigurationName element represents the name of a user configuration object.
  #
  # https://msdn.microsoft.com/en-us/library/office/dd899431(v=exchg.150).aspx
  class UserConfigurationName < Element
    key :name  # e.g. CategoryList
    element :folder_id, type: Identifier
  end
end

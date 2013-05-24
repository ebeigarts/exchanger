module Exchanger
  # The Room element represents a meeting room
  #
  # http://msdn.microsoft.com/en-us/library/dd899479(v=exchg.150).aspx
  class Room < Element
    element :id, :type => Address
  end

end

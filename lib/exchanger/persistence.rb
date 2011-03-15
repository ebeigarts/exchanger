module Exchanger
  module Persistence
    def new_record?
      not id
    end

    def save
      if new_record?
        create
      else
        update
      end
    end

    def destroy
      if new_record?
        false
      else
        delete
      end
    end

    # Reloads the +Element+ attributes from Exchanger.
    def reload
      if new_record?
        false
      else
        reloaded_element = self.class.find(self.id)
        @attributes = reloaded_element.attributes
        reset_modifications
        true
      end
    end
  end
end

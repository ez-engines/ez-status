module Ez
  module Status
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end

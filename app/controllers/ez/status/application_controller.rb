module Ez
  module Status
    class ApplicationController < ActionController::Base
      def view(cell_name, *args)
        render html: cell("ez/status/#{cell_name}", *args), layout: true
      end
    end
  end
end

# frozen_string_literal: true

module Ez
  module Status
    class ApplicationController < Ez::Status.config.status_base_controller.constantize
      def view(cell_name, *args)
        render html: cell("ez/status/#{cell_name}", *args), layout: true
      end
    end
  end
end

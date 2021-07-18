# frozen_string_literal: true

module Ez
  module Status
    class IndexCell < ApplicationCell
      def header
        Ez::Status.config.ui_header || 'Status'
      end

      def columns
        Ez::Status.config.columns
      end

      def monitors
        @monitors ||= Ez::Status.check_all
      end
    end
  end
end

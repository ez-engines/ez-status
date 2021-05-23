# frozen_string_literal: true

module Ez
  module Status
    class IndexCell < ApplicationCell
      def header
        Ez::Status.config.ui_header || 'Status'
      end

      def monitors
        @monitors ||= Ez::Status.config.monitors.each_with_object({}) do |monitor, acum|
          acum[monitor.name.demodulize] = monitor.new.check ? 'OK' : 'FAILURE'
        end
      end
    end
  end
end

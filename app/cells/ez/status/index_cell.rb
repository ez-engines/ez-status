# frozen_string_literal: true

module Ez
  module Status
    class IndexCell < ApplicationCell
      def header
        Ez::Status.config.ui_header || 'Status'
      end

      def monitors
        @monitors ||= Ez::Status.config.monitors.each_with_object([]) do |monitor, acum|
          is_working, msg, value = monitor.new.check
        rescue StandardError => e
          msg = e.message
        ensure
          acum << {
            name: monitor.name.demodulize,
            is_working: is_working ? 'OK' : 'FAILURE',
            msg: msg,
            value: value
          }
        end
      end
    end
  end
end

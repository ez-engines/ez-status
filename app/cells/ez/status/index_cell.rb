# frozen_string_literal: true

module Ez
  module Status
    class IndexCell < ApplicationCell
      OK = 'OK'
      FAILURE = 'FAILURE'

      def header
        Ez::Status.config.ui_header || 'Status'
      end

      def monitors
        @monitors ||= Ez::Status.config.monitors.map do |monitor|
          result, msg, value = monitor.new.check
          build_monitor_acum(monitor, result, msg, value)
        rescue StandardError => e
          msg = e.message
        ensure
          build_monitor_acum(monitor, result, msg, value)
        end
      end

      private

      def build_monitor_acum(monitor, result, msg, value)
        {
          name:   monitor.name.demodulize,
          result: result ? OK : FAILURE,
          msg:    msg,
          value:  value
        }
      end
    end
  end
end

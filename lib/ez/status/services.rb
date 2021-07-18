# frozen_string_literal: true

module Ez
  module Status
    module Services
      # Ez::Status.capture!
      module Store
        def capture!
          Ez::Status::Records.insert_all Ez::Status.check_all
        end
      end

      # Ez::Status.check_all
      module Monitors
        OK = 'OK'
        FAILURE = 'FAILURE'

        def check_all
          Ez::Status.config.monitors.map do |monitor|
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
            monitor_name: monitor.name.demodulize,
            result:       result ? OK : FAILURE,
            message:      msg,
            value:        value
          }
        end
      end
    end
  end
end

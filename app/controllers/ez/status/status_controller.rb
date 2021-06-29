# frozen_string_literal: true

module Ez
  module Status
    class StatusController < ApplicationController
      layout Ez::Status.config.layout || 'layouts/application'

      before_action :authenticate_with_basic_auth

      def index
        view 'index'
      end

      private

      def authenticate_with_basic_auth
        credentials = Ez::Status.config.basic_auth_credentials
        return true if credentials.blank?

        authenticate_or_request_with_http_basic do |email, password|
          email == credentials[:username] && password == credentials[:password]
        end
      end
    end
  end
end

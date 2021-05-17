require_dependency "ez/status/application_controller"

module Ez::Status
  class StatusController < ApplicationController
    def index
      view 'index'
    end
  end
end

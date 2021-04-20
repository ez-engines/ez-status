Rails.application.routes.draw do
  mount Ez::Status::Engine => "/ez-status"
end

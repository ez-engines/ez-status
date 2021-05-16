Rails.application.routes.draw do
  mount Ez::Status::Engine => "/status"
end

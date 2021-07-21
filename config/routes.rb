# frozen_string_literal: true

Ez::Status::Engine.routes.draw do
  scope module: 'ez/status' do
    root to: 'status#index'
  end
end

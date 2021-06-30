# frozen_string_literal: true

require 'rails_helper'
require 'ez/status/status_controller'

RSpec.describe Ez::Status::StatusController do
  routes { Ez::Status::Engine.routes }

  describe 'Application Layout' do
    context 'when default layout' do
      subject { get :index }

      it 'renders page' do
        expect(subject).to render_template('layouts/application')
      end
    end

    context 'when custom layout: layouts/custom_application' do
      around do |spec|
        Ez::Status.config.layout = 'layouts/custom_application'
        routes { Ez::Status::Engine.routes }

        spec.run
        Ez::Status.config.layout = nil
      end

      subject { get :index }

      it 'layout' do
        expect(subject).not_to render_template(layout: :application)
      end
    end

    context 'when missing template layouts/application_not_found' do
      around do |spec|
        Ez::Status.config.layout = 'layouts/application_not_found'
        spec.run
        Ez::Status.config.layout = nil
      end

      subject { get :index }

      it 'renders page' do
        expect(subject).to render_template('layouts/application_not_found')
      end
    end
  end
end

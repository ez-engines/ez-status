# frozen_string_literal: true

require 'rails_helper'

require 'ez/status/providers/database'
require 'ez/status/providers/cache'
require 'ez/status/providers/delayed_job'
require 'ez/status/providers/redis'
require 'ez/status/providers/sidekiq'

RSpec.describe '/status', type: :feature do
  describe 'Basic Authentication' do
    context 'custom' do
      around do |spec|
        Ez::Status.config.basic_auth_credentials = {
          username: username,
          password: password
        }
        spec.run
        Ez::Status.config.basic_auth_credentials = nil
      end

      before do
        encoded_login = ["#{username}:#{password}"].pack('m*')
        page.driver.header 'Authorization', "Basic #{encoded_login}"
        visit '/status'
      end

      let(:username) { 'MyUsername' }
      let(:password) { 'MyPassword' }

      it 'renders page' do
        expect(page).to have_selector 'h1', text: 'Status'
      end
    end

    context 'default: without basic auth credentials' do
      before do
        visit '/status'
      end

      it 'renders page' do
        expect(page).to have_selector 'h1', text: 'Status'
      end
    end
  end

  describe 'header' do
    context 'custom' do
      around do |spec|
        Ez::Status.config.ui_header = custom_text
        spec.run
        Ez::Status.config.ui_header = nil
      end

      before do
        visit '/status'
      end

      let(:custom_text) { 'My custom status header' }

      it 'renders h1 with user custom text' do
        expect(page).to have_selector 'h1', text: custom_text
      end
    end

    context 'default' do
      before { visit '/status' }

      it 'renders h1 with Status text' do
        expect(page).to have_selector 'h1', text: 'Status'
      end
    end
  end

  describe 'css_selectors' do
    context 'default' do
      before { visit '/status' }

      it 'decorate DOM with ez-status classes' do
        expect(page).to have_selector('.ez-status-index-container')
        expect(page).to have_selector('.ez-status-index-header')
        expect(page).to have_selector('.ez-status-index-main')
        expect(page).to have_selector('.ez-status-index-status')
        expect(page).to have_selector('.ez-status-index-check-name')
        expect(page).to have_selector('.ez-status-index-check-result')
      end
    end

    context 'custom' do
      around do |spec|
        Ez::Status.config.ui_custom_css_map = {
          'ez-status-index-container' => 'custom-status-index-container'
        }
        spec.run
        Ez::Status.config.ui_custom_css_map = {}
      end

      before { visit '/status' }

      it 'overrides with ui_custom_css_map' do
        expect(page).to_not have_selector('.ez-status-index-container')
        expect(page).to have_selector('.custom-status-index-container')
        # TODO: Spec all custom css overrides
      end
    end
  end

  describe 'check default providers' do
    let(:monitors) do
      [
        Ez::Status::Providers::Database,
        Ez::Status::Providers::Cache,
        Ez::Status::Providers::DelayedJob,
        Ez::Status::Providers::Redis,
        Ez::Status::Providers::Sidekiq
      ]
    end

    around do |spec|
      Ez::Status.config.monitors = monitors
      spec.run
      Ez::Status.config.monitors = []
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message for Database' do
        within('#Database') do
          expect(page).to have_content 'Database'
          expect(page).to have_content 'OK'
        end
      end

      it 'show success message for Cache' do
        within('#Cache') do
          expect(page).to have_content 'Cache'
          expect(page).to have_content 'OK'
        end
      end

      it 'show success message for DelayedJob' do
        within('#DelayedJob') do
          # rails generate delayed_job:active_record
          # rake db:migrate
          expect(page).to have_content 'DelayedJob'
          expect(page).to have_content 'OK'
        end
      end

      it 'show success message for Redis' do
        within('#Redis') do
          expect(page).to have_content 'Redis'
          expect(page).to have_content 'OK'
        end
      end

      it 'show success message for Sidekiq' do
        within('#Sidekiq') do
          expect(page).to have_content 'Sidekiq'
          expect(page).to have_content 'OK'
        end
      end
    end

    context 'failure' do
      before do
        monitors.each do |monitor|
          check_mock = instance_double(monitor, check: false)
          allow(monitor).to receive(:new).and_return(check_mock)
        end
        visit '/status'
      end

      it 'show failure message for Database' do
        within('#Database') do
          expect(page).to have_content 'Database'
          expect(page).to have_content 'FAILURE'
        end
      end

      it 'show failure message for Cache' do
        within('#Cache') do
          expect(page).to have_content 'Cache'
          expect(page).to have_content 'FAILURE'
        end
      end

      it 'show failure message for DelayedJob' do
        within('#DelayedJob') do
          expect(page).to have_content 'DelayedJob'
          expect(page).to have_content 'FAILURE'
        end
      end

      it 'show failure message for Redis' do
        within('#Redis') do
          expect(page).to have_content 'Redis'
          expect(page).to have_content 'FAILURE'
        end
      end
    end
  end
end

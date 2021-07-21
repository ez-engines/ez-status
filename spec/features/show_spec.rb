# frozen_string_literal: true

require 'rails_helper'

require 'ez/status/providers/database'
require 'ez/status/providers/cache'
require 'ez/status/providers/delayed_job'
require 'ez/status/providers/redis'
require 'ez/status/providers/sidekiq'

RSpec.describe '/status', type: :feature do
  describe 'Basic Authentication' do
    context 'when custom' do
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

    context 'when default: without basic auth credentials' do
      before do
        visit '/status'
      end

      it 'renders page' do
        expect(page).to have_selector 'h1', text: 'Status'
      end
    end
  end

  describe 'config.header' do
    context 'when custom' do
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

    context 'when default' do
      before { visit '/status' }

      it 'renders h1 with Status text' do
        expect(page).to have_selector 'h1', text: 'Status'
      end
    end
  end

  describe 'config.columns' do
    context 'when default' do
      before { visit '/status' }

      xit 'should default order' do
        # order = /#{item1.name}.*#{item2.name}/m
        # monitors = Ez::Status.check_all
        # Ez::Status::DEFAULT_COLUMNS.map{|col| "ez-status-index-check-monitor-name" monitors monitors}
        # expect(page.body).to match order
      end

      it 'expect monitor-name column' do
        expect(page).to have_selector('.ez-status-index-check-monitor-name')
        expect(page).to have_selector('.ez-status-index-check-monitor-name-span')
      end

      it 'expect result column' do
        expect(page).to have_selector('.ez-status-index-check-result')
        expect(page).to have_selector('.ez-status-index-check-result-span')
      end

      it 'expect message column' do
        expect(page).to have_selector('.ez-status-index-check-message')
        expect(page).to have_selector('.ez-status-index-check-message-span')
      end

      it 'expect value column' do
        expect(page).to have_selector('.ez-status-index-check-value')
        expect(page).to have_selector('.ez-status-index-check-value-span')
      end
    end

    context 'when custom' do
      around do |spec|
        Ez::Status.config.columns = %i[result monitor_name]
        spec.run
        Ez::Status.config.columns = Ez::Status::DEFAULT_COLUMNS
      end

      before { visit '/status' }

      xit 'should correct custom order' do
        # expect(page.body).to match order
      end

      it 'expect monitor-name column' do
        expect(page).to have_selector('.ez-status-index-check-monitor-name')
        expect(page).to have_selector('.ez-status-index-check-monitor-name-span')
      end

      it 'expect result column' do
        expect(page).to have_selector('.ez-status-index-check-result')
        expect(page).to have_selector('.ez-status-index-check-result-span')
      end

      it 'don\'t expect message column' do
        expect(page).not_to have_selector('.ez-status-index-check-message')
        expect(page).not_to have_selector('.ez-status-index-check-message-span')
      end

      it 'don\'t expect value column' do
        expect(page).not_to have_selector('.ez-status-index-check-value')
        expect(page).not_to have_selector('.ez-status-index-check-value-span')
      end
    end
  end

  describe 'config.ui_custom_css_map' do
    context 'when default' do
      before { visit '/status' }

      it 'decorate DOM with ez-status classes for container' do
        expect(page).to have_selector('.ez-status-index-container')
        expect(page).to have_selector('.ez-status-index-inner-container')
      end

      it 'decorate DOM with ez-status classes for header' do
        expect(page).to have_selector('.ez-status-index-header')
        expect(page).to have_selector('.ez-status-index-title')
        expect(page).to have_selector('.ez-status-index-title-span')
      end

      it 'decorate DOM with ez-status classes for monitors' do
        expect(page).to have_selector('.ez-status-index-monitors-collection')
      end

      xit 'decorate DOM with ez-status classes for monitor' do
        expect(page).to have_selector('.ez-status-index-status')
        expect(page).to have_selector('.ez-status-index-failed')
      end

      it 'decorate DOM with ez-status classes for message' do
        expect(page).to have_selector('.ez-status-index-check-message')
        expect(page).to have_selector('.ez-status-index-check-message-span')
      end

      it 'decorate DOM with ez-status classes for value' do
        expect(page).to have_selector('.ez-status-index-check-value')
        expect(page).to have_selector('.ez-status-index-check-value-span')
      end

      it 'decorate DOM with ez-status classes for result' do
        expect(page).to have_selector('.ez-status-index-check-result')
        expect(page).to have_selector('.ez-status-index-check-result-span')
      end

      it 'decorate DOM with ez-status classes for name' do
        expect(page).to have_selector('.ez-status-index-check-monitor-name')
        expect(page).to have_selector('.ez-status-index-check-monitor-name-span')
      end
    end

    context 'when custom' do
      around do |spec|
        Ez::Status.config.ui_custom_css_map = {
          'ez-status-index-container' => 'custom-status-index-container'
        }
        spec.run
        Ez::Status.config.ui_custom_css_map = {}
      end

      before { visit '/status' }

      it 'overrides with ui_custom_css_map' do
        expect(page).not_to have_selector('.ez-status-index-container')
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

    context 'when success' do
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

    context 'when failure' do
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

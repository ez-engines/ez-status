# frozen_string_literal: true

require 'rails_helper'

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
        encoded_login = ["#{username}:#{password}"].pack("m*")
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

  describe 'check Cache provider' do
    around do |spec|
      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::Cache ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cache'
        expect(page).to have_content 'OK'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::Cache, check: false)
        allow(Ez::Status::Providers::Cache).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cache'
        expect(page).to have_content 'FAILURE'
      end
    end
  end

  describe 'check Database provider' do
    around do |spec|
      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::Database ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Database'
        expect(page).to have_content 'OK'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::Database, check: false)
        allow(Ez::Status::Providers::Database).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Database'
        expect(page).to have_content 'FAILURE'
      end
    end
  end

  describe 'check DelayedJob provider' do
    around do |spec|
      require 'ez/status/providers/delayed_job'

      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::DelayedJob ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::DelayedJob, check: [true, 'connected', 200])
        allow(Ez::Status::Providers::DelayedJob).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'DelayedJob'
        expect(page).to have_content 'OK'
        expect(page).to have_content 'connected'
        expect(page).to have_content '20'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::DelayedJob, check: false)
        allow(Ez::Status::Providers::DelayedJob).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'DelayedJob'
        expect(page).to have_content 'FAILURE'
      end
    end
  end

  describe 'check Redis provider' do
    around do |spec|
      require 'ez/status/providers/redis'

      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::Redis ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Redis'
        expect(page).to have_content 'OK'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::Redis, check: false)
        allow(Ez::Status::Providers::Redis).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Redis'
        expect(page).to have_content 'FAILURE'
      end
    end
  end

  describe 'check Resque provider' do
    around do |spec|
      require 'ez/status/providers/resque'

      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::Resque ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Resque'
        expect(page).to have_content 'OK'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::Resque, check: false)
        allow(Ez::Status::Providers::Resque).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Resque'
        expect(page).to have_content 'FAILURE'
      end
    end
  end

  describe 'check Sidekiq provider' do
    around do |spec|
      require 'ez/status/providers/sidekiq'

      Ez::Status.configure do |config|
        config.monitors = [ Ez::Status::Providers::Sidekiq ]
      end
      spec.run
      Ez::Status.configure { |config| config.monitors = [] }
    end

    context 'success' do
      before { visit '/status' }

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Sidekiq'
        expect(page).to have_content 'OK'
      end
    end

    context 'failure' do
      before do
        database_check_mock = instance_double(Ez::Status::Providers::Sidekiq, check: false)
        allow(Ez::Status::Providers::Sidekiq).to receive(:new).and_return(database_check_mock)
        visit '/status'
      end

      it 'show failure message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Sidekiq'
        expect(page).to have_content 'FAILURE'
      end
    end
  end
end

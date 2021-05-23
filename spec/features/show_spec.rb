require 'rails_helper'

RSpec.describe '/status', type: :feature do
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

  describe 'database check' do
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

      it 'show success message' do
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Database'
        expect(page).to have_content 'FAILURE'
      end
    end
  end
end

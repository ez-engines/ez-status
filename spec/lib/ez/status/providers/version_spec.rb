# frozen_string_literal: true

require 'ez/status/version'

RSpec.describe 'Ez::Status::VERSION' do
  describe 'VERSION' do
    it 'return correct version' do
      expect(Ez::Status::VERSION).to be_eql '0.1.0'
    end
  end
end

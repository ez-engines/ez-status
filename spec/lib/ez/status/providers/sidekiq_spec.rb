# frozen_string_literal: true

require 'rails_helper'
require 'ez/status/providers/sidekiq'
require 'sidekiq'

RSpec.describe Ez::Status::Providers::Sidekiq do
  describe 'check' do
    context 'when successes' do
      it 'return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'when failure' do
      before do
        allow(Sidekiq).to receive(:redis) { raise 'error' }
      end

      it 'return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::SidekiqException)
      end
    end
  end
end

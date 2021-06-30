# frozen_string_literal: true

require 'rails_helper'
require 'ez/status/providers/database'

RSpec.describe Ez::Status::Providers::Database do
  describe 'check' do
    let(:time_now) { Time.now.to_s }

    context 'when successes' do
      before do
        allow(ActiveRecord::Base).to receive(:establish_connection).and_return true
        allow(ActiveRecord::Base).to receive(:connection).and_return true
        allow(ActiveRecord::Base).to receive(:connected?).and_return true
      end

      it 'return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'when failure' do
      before do
        allow(ActiveRecord::Base).to receive(:establish_connection) { raise 'error' }
      end

      it 'return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::DatabaseException)
      end
    end
  end
end

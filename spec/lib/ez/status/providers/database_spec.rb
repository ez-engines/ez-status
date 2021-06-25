# frozen_string_literal: true

require 'rails_helper'
require 'ez/status/providers/database'

RSpec.describe Ez::Status::Providers::Database do
  describe 'check' do
    let(:time_now) { Time.now.to_s }

    context 'successes' do
      before do
        allow(ActiveRecord::Base).to receive(:establish_connection) { true }
        allow(ActiveRecord::Base).to receive(:connection) { true }
        allow(ActiveRecord::Base).to receive(:connected?) { true }
      end

      it 'should return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'failure' do
      before do
        allow(ActiveRecord::Base).to receive(:establish_connection) { raise 'error' }
      end

      it 'should return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::DatabaseException)
      end
    end
  end
end

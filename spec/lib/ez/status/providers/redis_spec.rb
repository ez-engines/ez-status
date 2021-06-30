# frozen_string_literal: true

require 'rails_helper'
require 'ez/status/providers/redis'

RSpec.describe Ez::Status::Providers::Redis do
  describe 'check' do
    context 'when successes' do
      it 'return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'when failure' do
      before do
        allow_any_instance_of(Redis).to receive(:set) { raise 'error' }
      end

      it 'return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::RedisException)
      end
    end
  end
end

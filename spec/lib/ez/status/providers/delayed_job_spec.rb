# frozen_string_literal: true

require 'delayed_job'
require 'ez/status/providers/delayed_job'

RSpec.describe Ez::Status::Providers::DelayedJob do
  describe 'check' do
    context 'when successes' do
      it 'return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'when failure' do
      before do
        error = StandardError.new('service not working')
        allow(::Delayed::Job).to receive(:count).and_raise(error)
      end

      it 'return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::DelayedJobException)
      end
    end
  end
end

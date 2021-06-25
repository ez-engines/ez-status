# frozen_string_literal: true

require 'delayed_job'
require 'ez/status/providers/delayed_job'

RSpec.describe Ez::Status::Providers::DelayedJob do
  describe 'check' do
    # context 'successes' do
    #   before(:each) do
    #     # error = StandardError.new('service not working')
    #     # allow_any_instance_of(described_class).to receive(:establish_connection).and_raise(error)
    #   end
    #
    it 'should return answer' do
      expect(described_class.new.check).to be_eql true
    end

    context 'failure' do
      before(:each) do
        error = StandardError.new('service not working')
        allow(::Delayed::Job).to receive(:count).and_raise(error)
      end

      it 'should return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::DelayedJobException)
      end
    end
  end
end

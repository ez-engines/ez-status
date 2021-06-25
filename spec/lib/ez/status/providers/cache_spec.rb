require 'rails'
require 'ez/status/providers/cache'

RSpec.describe Ez::Status::Providers::Cache do
  describe 'check' do
    let(:time_now) { Time.now.to_s }

    context 'successes' do
      before(:each) do
        allow(Rails.cache).to receive(:write).with(described_class.to_s, time_now).and_return(true)
        allow(Rails.cache).to receive(:read).with(described_class.to_s).and_return(time_now)
        allow_any_instance_of(described_class).to receive(:time_now).and_return(time_now)
      end

      it 'should return answer' do
        expect(described_class.new.check).to be_eql true
      end
    end

    context 'failure' do
      before(:each) do
        error = StandardError.new('service not working')
        allow_any_instance_of(described_class).to receive(:time_now).and_raise(error)
      end

      it 'should return answer' do
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::CacheException)
      end
    end
  end
end

require 'ez/status/providers/sidekiq'
require 'sidekiq'

RSpec.describe Ez::Status::Providers::Sidekiq do
  describe 'check' do
    let(:time_now) { Time.now.to_s }

    context 'successes' do
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
        expect { described_class.new.check }.to raise_error(Ez::Status::Providers::SidekiqException)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ez::Status do
  let(:result) do
    [
      { monitor_name: 'Database', result: 'OK', message: nil, value: nil },
      { monitor_name: 'Cache', result: 'FAILURE', message: nil, value: nil }
    ]
  end

  describe 'Monitors' do
    let(:monitors) { described_class.check_all }

    context 'when check_all' do
      it 'is Array' do
        expect(monitors).to be_a Array
      end

      it 'is not empty' do
        expect(monitors).not_to be_empty
      end

      it 'all monitors be Hash' do
        expect(monitors).to all be_a(Hash)
      end

      it 'matches include result' do
        expect(monitors).to match_array(result)
      end
    end
  end

  describe 'Store' do
    let(:capture) { described_class.capture! }

    describe 'capture!' do
      it 'saves results to DB' do
        expect(Ez::Status::Records.count).to be 0
        capture
        expect(Ez::Status::Records.count).to be 2
      end
    end
  end
end

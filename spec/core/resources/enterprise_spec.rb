# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Enterprise do
  let(:attributes) { { 'id' => 'ent-123', 'name' => 'Test Enterprise' } }
  subject { DevinApi::Resources::Enterprise.new(client, attributes) }

  describe '#initialize' do
    it 'inherits from Base resource' do
      expect(subject).to be_a(DevinApi::Resources::Base)
    end

    it 'sets attributes' do
      expect(subject.id).to eq('ent-123')
      expect(subject.name).to eq('Test Enterprise')
    end
  end

  describe '#audit_logs' do
    before do
      allow(client).to receive(:get).with('/v1/enterprise/audit-logs', {}).and_return(
        {
          'audit_logs' => [
            { 'created_at' => 1_704_067_200_000, 'action' => 'login', 'ip' => '1.1.1.1', 'user_id' => 'email@abcd', 'session_id' => 'ABCD' },
            { 'created_at' => 1_704_153_600_000, 'action' => 'add_member', 'target_user_id' => 'email@efgh' }
          ]
        }
      )
    end

    it 'returns audit logs' do
      response = subject.audit_logs
      expect(response).to be_a(Hash)
      expect(response['audit_logs']).to be_an(Array)
      expect(response['audit_logs'].first['action']).to eq('login')
      expect(response['audit_logs'].first['user_id']).to eq('email@abcd')
    end
  end

  describe '#consumption' do
    before do
      allow(client).to receive(:get).with('/v1/enterprise/consumption', {}).and_return(
        {
          'total_acus' => 1000,
          'period_start' => '2024-01-01T00:00:00Z',
          'period_end' => '2024-01-31T23:59:59Z',
          'breakdown' => { 'sessions' => 800, 'knowledge' => 100, 'other' => 100 }
        }
      )
    end

    it 'returns consumption data' do
      response = subject.consumption
      expect(response).to be_a(Hash)
      expect(response['total_acus']).to eq(1000)
      expect(response['period_start']).to eq('2024-01-01T00:00:00Z')
      expect(response['period_end']).to eq('2024-01-31T23:59:59Z')
      expect(response['breakdown']).to be_a(Hash)
      expect(response['breakdown']['sessions']).to eq(800)
    end
  end
end

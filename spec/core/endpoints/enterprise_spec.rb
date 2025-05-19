# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Enterprise do
  subject { client }

  it 'should respond to enterprise method' do
    expect(subject).to respond_to(:enterprise)
  end

  it 'should return a DevinApi::Collection for enterprise' do
    expect(subject.enterprise).to be_a(DevinApi::Collection)
  end

  describe '#list_audit_logs' do
    before do
      stub_request(:get, 'https://api.example.com/v1/enterprise/audit-logs')
        .to_return(
          status: 200,
          body: '{
            "audit_logs":[
              {"created_at":1704067200000,"action":"login","ip":"1.1.1.1","user_id":"email@abcd","session_id":"ABCD"},
              {"created_at":1704153600000,"action":"add_member","target_user_id":"email@efgh"},
              {"created_at":1704240000000,"action":"assign_roles","target_user_id":"email@efgh","roles":["org:admin"]}
            ]
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should list audit logs' do
      response = subject.list_audit_logs
      expect(response).to be_a(Hash)
      expect(response['audit_logs']).to be_an(Array)
      expect(response['audit_logs'].first['action']).to eq('login')
      expect(response['audit_logs'].first['user_id']).to eq('email@abcd')
    end
  end

  describe '#get_enterprise_consumption' do
    before do
      stub_request(:get, 'https://api.example.com/v1/enterprise/consumption')
        .to_return(
          status: 200,
          body: '{
            "total_acus":1000,
            "period_start":"2024-01-01T00:00:00Z",
            "period_end":"2024-01-31T23:59:59Z",
            "breakdown":{"sessions":800,"knowledge":100,"other":100}
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should get enterprise consumption data' do
      response = subject.get_enterprise_consumption
      expect(response).to be_a(Hash)
      expect(response['total_acus']).to eq(1000)
      expect(response['period_start']).to eq('2024-01-01T00:00:00Z')
      expect(response['period_end']).to eq('2024-01-31T23:59:59Z')
      expect(response['breakdown']).to be_a(Hash)
      expect(response['breakdown']['sessions']).to eq(800)
    end
  end
end

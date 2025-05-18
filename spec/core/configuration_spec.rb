# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Configuration do
  subject { DevinApi::Configuration.new }

  it 'should properly set url option' do
    url = 'https://api.devin.com'
    subject.url = url
    expect(subject.url).to eq(url)
  end

  it 'should properly set access_token option' do
    token = 'test_token'
    subject.access_token = token
    expect(subject.access_token).to eq(token)
  end

  it 'should properly set logger option' do
    logger = Logger.new($stdout)
    subject.logger = logger
    expect(subject.logger).to eq(logger)
  end

  it 'should initialize options as empty hash' do
    expect(subject.options).to eq({})
  end

  it 'should properly merge options' do
    subject.options[:headers] = { 'User-Agent' => 'Test Agent' }
    expect(subject.options[:headers]['User-Agent']).to eq('Test Agent')
  end
end

require 'spec_helper'

describe Queued::Client do
  let!(:client) { Queued::Client.new('http://example.com') }

  it 'raises errors' do
    stub_request(:get, 'http://example.com/foo').to_return(
      status: 500,
      headers: { 'Content-Type' => 'application/json' },
      body: '{"error": "Something went wrong"}')

    expect { client.get '/foo' }.to raise_error(Queued::InternalServerError)
  end

  it 'sends auth info' do
    stub_request(:get, 'http://:testing@example.com/foo')

    client = Queued::Client.new('http://example.com', auth: 'testing')
    client.get '/foo'

    assert_requested :get, 'http://:testing@example.com/foo', times: 1
  end

  describe '#queue' do
    it 'should return queue' do
      expect(client.queue(:foo)).to be_a(Queued::Queue)
    end
  end
end
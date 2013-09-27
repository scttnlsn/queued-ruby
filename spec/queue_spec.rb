require 'spec_helper'

describe Queued::Queue do
  let!(:client) { Queued::Client.new('http://example.com') }
  let!(:queue) { Queued::Queue.new(client, 'foo') }

  describe '#enqueue' do
    before :each do
      stub_request(:post, 'http://example.com/foo').
        to_return(headers: { 'Location' => 'http://example.com/foo/1' })
    end

    it 'posts to enqueue endpoint' do
      queue.enqueue('bar')

      assert_requested :post, 'http://example.com/foo',
        headers: { 'Content-Type' => 'text/plain' },
        body: 'bar',
        times: 1
    end

    it 'returns enqueued item' do
      item = queue.enqueue('bar')

      expect(item).to be_a(Queued::Item)
      expect(item.value).to eq 'bar'
      expect(item.type).to eq 'text/plain'
      expect(item.url).to eq 'http://example.com/foo/1'
    end

    it 'encodes JSON values' do
      queue.enqueue({ bar: 'baz' }, 'application/json')

      assert_requested :post, 'http://example.com/foo',
        headers: { 'Content-Type' => 'application/json' },
        body: '{"bar":"baz"}',
        times: 1
    end
  end

  describe '#dequeue' do
    it 'posts to dequeue endpoint' do
      stub_request(:post, 'http://example.com/foo/dequeue?timeout=2&wait=1').to_return(
        headers: { 'Content-Type' => 'text/plain', 'Location' => 'http://example.com/foo/1' },
        body: 'bar')

      queue.dequeue(wait: 1, timeout: 2)
      assert_requested :post, 'http://example.com/foo/dequeue?timeout=2&wait=1', times: 1
    end

    it 'returns dequeued item' do
      stub_request(:post, 'http://example.com/foo/dequeue').to_return(
        headers: { 'Content-Type' => 'text/plain', 'Location' => 'http://example.com/foo/1' },
        body: 'bar')

      item = queue.dequeue()

      expect(item).to be_a(Queued::Item)
      expect(item.value).to eq 'bar'
      expect(item.type).to eq 'text/plain'
      expect(item.url).to eq 'http://example.com/foo/1'
    end

    it 'returns nil on 404' do
      stub_request(:post, 'http://example.com/foo/dequeue').to_return(status: 404)

      item = queue.dequeue()

      expect(item).to be_nil
    end

    it 'parses JSON responses' do
      stub_request(:post, 'http://example.com/foo/dequeue').to_return(
        headers: { 'Content-Type' => 'application/json', 'Location' => 'http://example.com/foo/1' },
        body: '{"bar":"baz"}')

      item = queue.dequeue()

      expect(item).to be_a(Queued::Item)
      expect(item.type).to eq 'application/json'
      expect(item.value).to eq 'bar' => 'baz'
    end
  end
end
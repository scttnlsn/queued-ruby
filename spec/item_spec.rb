require 'spec_helper'

describe Queued::Item do
  let!(:client) { Queued::Client.new('http://example.com') }
  let!(:item) { Queued::Item.new(client, url: 'http://example.com/foo/1') }

  describe '#complete' do
    before :each do
      stub_request(:delete, 'http://example.com/foo/1')
    end

    it 'deletes to complete endpoint' do
      item.complete()
      assert_requested :delete, 'http://example.com/foo/1', times: 1
    end
  end
end
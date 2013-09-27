module Queued
  class Item
    attr_reader :value, :type, :url

    def initialize(client, options = {})
      @client = client
      @value = options[:value]
      @type = options[:type]
      @url = options[:url]
    end

    def complete
      @client.delete @url
      self
    end
  end
end
require 'faraday'
require 'faraday_middleware'

module Queued
  class Client
    def initialize(url, options = {})
      @url = url
      @auth = options[:auth]

      @conn = Faraday.new(:url => @url) do |conn|
        conn.use Middleware::Errors

        conn.request :json
        conn.response :json, :content_type => /\bjson$/
        
        conn.adapter Faraday.default_adapter
      end

      if @auth
        @conn.basic_auth('', @auth)
      end
    end

    def queue(name)
      Queue.new(self, name)
    end

    [:get, :post, :put, :delete].each do |method|
      define_method method do |*args, &block|
        @conn.send(method, *args, &block)
      end
    end
  end
end
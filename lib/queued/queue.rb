module Queued
  class Queue
    def initialize(client, name)
      @client = client
      @name = name
    end

    def enqueue(value, type = 'text/plain')
      res = @client.post do |req|
        req.url "/#{@name}"
        req.headers['Content-Type'] = type
        req.body = value
      end

      Item.new(@client,
        value: value,
        type: type,
        url: res.headers['Location'])
    end

    def dequeue(params = {})
      res = @client.post do |req|
        req.url "/#{@name}/dequeue"
        req.params[:wait] = params[:wait] if params[:wait]
        req.params[:timeout] = params[:timeout] if params[:timeout]
      end

      return nil if res.status === 404

      Item.new(@client,
        value: res.body,
        type: res.headers['Content-Type'],
        url: res.headers['Location'])
    end
  end
end
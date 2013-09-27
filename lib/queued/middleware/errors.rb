module Queued
  class Error < StandardError; end
  class BadRequest < Error; end
  class Unauthorized < Error; end
  class InternalServerError < Error; end

  module Middleware
    ERROR_MAP = {
      400 => BadRequest,
      401 => Unauthorized,
      500 => InternalServerError
    }

    class Errors < Faraday::Response::Middleware
      def on_complete(env)
        return unless error = ERROR_MAP[env[:status]]
        raise error, error_message(env[:body])
      end

      private

      def error_message(body)
        if body && body.is_a?(Hash)
          body['error']
        else
          body
        end
      end
    end
  end
end
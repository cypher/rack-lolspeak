require 'lolspeak'

module Rack
  module Contrib
    class ICanHazLOLCode
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        [status, headers, body]
      end
    end
  end
end

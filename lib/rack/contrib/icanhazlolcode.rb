require 'lolspeak'

module Rack
  module Contrib
    class ICanHazLOLCode
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        if headers['Content-Type'] == 'text/html'
          body = body.to_lolspeak
          headers['Content-Length'] = body.size.to_s
        end

        [status, headers, body]
      end
    end
  end
end

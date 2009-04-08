require 'lolspeak'
require 'hpricot'

module Rack
  module Contrib
    class ICanHazLOLCode
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        case headers['Content-Type']
        when 'text/plain'
          body = body.to_lolspeak
          headers['Content-Length'] = body.size.to_s
        end

        [status, headers, body]
      end
    end
  end
end

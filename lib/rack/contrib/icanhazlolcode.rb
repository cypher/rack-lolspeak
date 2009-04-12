require 'lolspeak'
require 'hpricot'

module Rack
  module Contrib
    class ICanHazLOLCode
      def initialize(app)
        @app = app
      end

      def lolify(elem)
        case elem
        when Hpricot::Elem
          elem.children.each { |e| lolify(e) } if elem.children
        when Hpricot::Text
          elem.content = elem.to_s.to_lolspeak.strip
        else
          puts "Don't know what that is"
        end
      end

      def call(env)
        status, headers, body = @app.call(env)

        case headers['Content-Type']
        when 'text/plain'
          body = body.to_lolspeak
          headers['Content-Length'] = body.size.to_s
        when 'text/html'
          doc = Hpricot(body)

          # Swap out the title
          title = doc.at('title')
          title.inner_html = title.inner_html.to_lolspeak if title

          # Swap out stuff inside the elements
          elements = doc.search('body')
          elements.each do |elem|
            lolify(elem)
          end

          body = doc.to_html
          headers['Content-Length'] = body.size.to_s
        end

        [status, headers, body]
      end
    end
  end
end

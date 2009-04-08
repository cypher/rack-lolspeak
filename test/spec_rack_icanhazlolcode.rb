require 'test/spec'
require 'rack/mock'
require 'rack/contrib/icanhazlolcode'

context "Rack::Contrib::ICanHazLOLCode" do
  context "text/plain" do
    app = lambda {|env| [200, {'Content-Type' => 'text/plain'}, "Hello, kitty"] }

    specify "should convert the body to lolspeak" do
      status, headers, body = Rack::Contrib::ICanHazLOLCode.new(app).call({})

      status.should.equal 200
      body.should.equal "y halo thar, kitty"
    end
  end
end

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

  context 'text/html' do
    page_title = "This is the document's title"
    title = "Glorious title of document!"
    div = "Here is the content of a div, which is going to be lolcatted"
    paragraph = ""
    app = lambda do |env|
      body = <<"HTML"
<html>
  <head>
    <title>#{page_title}</title>
  </head>
  <body>
    <h1>#{title}</h1>
    <div>
      #{div}
      <p>
        #{paragraph}
      </p>
    </div>
  </body>
</html>
HTML

      [200, {'Content-Type' => 'text/html'}, body]
    end

    specify "should convert the title to lolspeak" do
      status, headers, body = Rack::Contrib::ICanHazLOLCode.new(app).call({})

      status.should.equal 200

      doc = Hpricot(body)
      doc.search('title').inner_html.should.equal page_title.to_lolspeak
    end

    specify "should convert the body to lolspeak" do
      status, headers, body = Rack::Contrib::ICanHazLOLCode.new(app).call({})

      status.should.equal 200

      doc = Hpricot(body)
      doc.search('h1').inner_html.should.equal title.to_lolspeak
      doc.search('div').inner_html.should.equal div.to_lolspeak
      doc.search('p').inner_html.should.equal paragraph.to_lolspeak
    end

    specify "should preserve the HTML tags" do
      status, headers, body = Rack::Contrib::ICanHazLOLCode.new(app).call({})

      status.should.equal 200

      doc = Hpricot(body)
      doc.search('h1').should.not.equal nil
      doc.search('div').should.not.equal nil
      doc.search('p').should.not.equal nil
    end
  end
end

require './secrets'

Encryptor.default_options.merge!(:key => SECRET_KEY)

class Application < Sinatra::Base
  register Sinatra::AssetPipeline
  set :assets_precompile, %w{application.css application.js *.png *.jpg *.gif}

  helpers do
    def credentials
      @credentials ||= if base64 = request.cookies['credentials']
        begin
          MultiJson.load Base64.decode64(base64).decrypt
        rescue
          nil
        end
      end
    end
  end
  
  get '/' do
    if credentials
      erb :index
    else
      erb :sign_in
    end
  end

  get '/faq' do
    erb :faq
  end

  post '/credentials' do
    json = MultiJson.dump params[:credentials]
    encrypted = json.encrypt
    base64 = Base64.encode64(encrypted)
    response.set_cookie "credentials", value: base64, path: "/", expires: Time.new(2020,1,1)
    redirect "/"
  end

  get "/sign_out" do
    response.delete_cookie "credentials"
    redirect "/"
  end

  post '/scrape.?:format?', provides: 'json' do
    content_type "application/json"

    balance = RejsekortScraper.new(credentials['username'], credentials['password']).balance

    if balance
      MultiJson.dump(balance: balance)
    else
      status 401
      { error: "Intet resultat" }
    end
  end

end

class RejsekortScraper

  def initialize(username, password)
    @username = username
    @password = password
  end

  def balance
    @balance ||= scrape
  end

  private

  def scrape
    agent = Mechanize.new

    page = agent.get("https://selvbetjening.rejsekort.dk/CommercialWebSite")
    form = page.forms.first
    form.registeredLogin = @username
    form.password = @password

    page = form.submit(form.buttons.first)

    balance = page.parser.css("#cardinfo h1").text.match(/\d+,\d{2}/).to_s.strip
    if balance == "" then nil else balance end
  end
end

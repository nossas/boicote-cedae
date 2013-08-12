require "action_mailer"

require "./models/user"
require "./mailers/user_mailer"

class BoicoteCedae < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  configure do
    set :haml, { format: :html5, escape_html: true }

    Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))

    Compass.configuration do |config|
      config.project_path = File.dirname(__FILE__)
      config.sass_dir = 'views'
    end

    set :sass, Compass.sass_engine_options
    ActionMailer::Base.view_paths = File.join(Sinatra::Application.root, 'views')
  end

  configure :development do
    set :database, 'sqlite:///db/development.sqlite'
    ActionMailer::Base.delivery_method = :test
  end

  configure :production do
    db = URI.parse ENV['DATABASE_URL']

    ActiveRecord::Base.establish_connection(
      adapter:   db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host:      db.host,
      username:  db.user,
      password:  db.password,
      database:  db.path[1..-1],
      encoding:  'utf8'
    )

    ActionMailer::Base.smtp_settings = {
      address: "smtp.sendgrid.net",
      port: '25',
      authentication: :plain,
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      domain: ENV['SENDGRID_DOMAIN'],
    }
  end

  get "/" do
    @counter = User.count
    haml :index
  end

  get "/counter.json" do
    content_type "application/json"

    { total: User.count }.to_json
  end

  post "/counter.json" do
    content_type "application/json"

    user = User.new(params[:user])

    if user.save
      { total: User.count }.to_json
    else
      status 406
      field, message = user.errors.first
      { message: message, field: field }.to_json
    end
  end

  get '/stylesheets/:file.css' do
    content_type 'text/css', charset: 'utf-8'
    sass :"stylesheets/#{params[:file]}"
  end
end

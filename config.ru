require "bundler"
Bundler.require

use Rack::Coffee, root: 'public', urls: '/javascripts'

use Rack::Static,
  :urls => ["/images"],
  :root => "public"

require './boicote_cedae'
run BoicoteCedae

require 'bundler'
Bundler.setup

require 'rack/test'

describe 'Sprockets 4 with Rack' do
  include Rack::Test::Methods
  let(:app) {
    Rack::Builder.parse_file(__dir__ + '/../config.ru').first
  }
  
  context 'ES6 module file' do
    it 'serves raw contents of an ES6 module' do
      get '/say_hi.es6'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/ecmascript-6')
      expect(last_response.body).to include('export default function')
    end
  
    it 'serves compiled contents of an ES6 module' do
      get '/say_hi.js'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/javascript')
      expect(last_response.body).to include('Object.defineProperty(exports, "__esModule"')
    end
    
    it 'serves the source map for the module'
  end
  
  context 'CoffeeScript' do
    it 'serves raw Coffeescript' do
      get '/a_class.coffee'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('text/coffeescript')
      expect(last_response.body).to include('quack: ->')
    end
    
    it 'serves compiled CoffeeScript' do
      get '/a_class.js'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/javascript')
      expect(last_response.body).to include('Duck.prototype.quack')
    end
    
    it 'serves the source map for the file'
  end
end 
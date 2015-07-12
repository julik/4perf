require 'bundler'
Bundler.setup

require 'rack/test'

describe 'Sprockets 4 with Rack' do
  include Rack::Test::Methods
  let(:app) {
    Rack::Builder.parse_file(__dir__ + '/../config.ru').first
  }
  
  it 'serves the shell HTML at /' do
    get '/'
    expect(last_response.content_type).to eq('text/html')
    expect(last_response.body).to include('Experimental page of 4perf')
  end
  
  context 'ES6 module file' do
    it 'serves raw contents of an ES6 module' do
      get '/assets/say_hi.es6'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/ecmascript-6')
      expect(last_response.body).to include('export default function')
    end
  
    it 'serves compiled contents of an ES6 module' do
      get '/assets/say_hi.js'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/javascript')
      expect(last_response.body).to include('Object.defineProperty(exports, "__esModule"')
      expect(last_response['X-SourceMap']).to eq("/assets/say_hi.js.map")
    end
    
    it 'serves the source map for the module' do
      get '/assets/say_hi.js.map'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to be_nil
      expect(last_response.content_type).to include('sourcemap')
      expect(last_response.body).to include('mappings')
    end
  end
  
  context 'CoffeeScript' do
    it 'serves raw Coffeescript' do
      get '/assets/a_class.coffee'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('text/coffeescript')
      expect(last_response.body).to include('quack: ->')
    end
    
    it 'serves compiled CoffeeScript' do
      get '/assets/a_class.js'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to eq("/assets/a_class.js.map")
      expect(last_response.content_type).to include('application/javascript')
      expect(last_response.body).to include('Duck.prototype.quack')
    end
    
    it 'serves the source map for the file' do
      get '/assets/a_class.js.map'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to be_nil
      expect(last_response.content_type).to include('sourcemap')
      expect(last_response.body).to include('mappings')
    end
  end
  
  context 'application.es6 that uses an ES6 require' do
    it 'serves raw ES6' do
      get '/assets/application.es6'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('application/ecmascript-6')
      expect(last_response.body).to include('import sayer from')
    end
    
    it 'serves compiled JS' do
      get '/assets/application.js'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to eq("/assets/application.js.map")
      expect(last_response.content_type).to include('application/javascript')
      expect(last_response.body).to include('function _interopRequireDefault')
    end
    
    it 'serves the source map for the file' do
      get '/assets/application.js.map'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to be_nil
      expect(last_response.content_type).to include('sourcemap')
      puts last_response.body.inspect
      expect(last_response.body).to include('mappings')
    end
  end
end 
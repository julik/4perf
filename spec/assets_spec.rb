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
  
  def expect_source_mapping_in(json_response_str)
    parsed = JSON.load(json_response_str)
    expect(parsed).to have_key("mappings"), "Sourcemap JSON must have the 'mappings' key"
    
    mappings = parsed['mappings']
    expect(mappings).not_to be_empty, ":mappings should contain, well, the effin sourcemaps - but was empty"
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
      expect_source_mapping_in(last_response.body)
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
      expect_source_mapping_in(last_response.body)
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
      expect_source_mapping_in(last_response.body)
    end
  end
  
  context 'SASS via SCSS' do
    it 'serves raw SCSS' do
      get '/assets/style.scss'
      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to include('text/scss')
      expect(last_response.body).to include("\n  p {")
    end
    
    it 'serves compiled CSS' do
      get '/assets/style.css'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to eq("/assets/style.css.map")
      expect(last_response.content_type).to include('text/css')
      expect(last_response.body).to include('.f p {')
    end
    
    it 'serves the source map for the file' do
      get '/assets/style.css.map'
      expect(last_response.status).to eq(200)
      expect(last_response['X-SourceMap']).to be_nil
      expect(last_response.content_type).to include('sourcemap')
      expect_source_mapping_in(last_response.body)
    end
  end
end 
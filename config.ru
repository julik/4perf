require 'sprockets'

Dir.glob(File.dirname(__FILE__) + '/hacks/*.rb').each do | sprockets_hack_path |
  require sprockets_hack_path
end

map '/assets' do
  use SourceMapExposer
  run Sprockets::Environment.new.tap{|e|
    e.append_path File.dirname(__FILE__) + '/assets'
  }
end

map '/' do
  run ->(env) {
    [200, {'Content-Type' => 'text/html'}, [File.read(__dir__ + '/index.html')]]
  }
end
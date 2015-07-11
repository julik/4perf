require 'sprockets'

run Sprockets::Environment.new.tap{|e|
  e.append_path File.dirname(__FILE__) + '/assets'
}
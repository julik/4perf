# Required because Sprockets does not expose source maps on it's own (bug/unfinished).
# It looks like currently Sprockets _does_ serve sourcemaps under "compiled.file.ext.map"
# but you also have to _indicate_ to the browser that this map is available at all - and
# this functionality seems to be unfinished.
class SourceMapExposer
  def initialize(sprockets_env)
    @sprockets = sprockets_env
  end
  
  def call(env)
    s, h, b = @sprockets.call(env)
    if s > 199 && s < 300 && !h['X-SourceMap'] && !env['PATH_INFO'].include?('.map')
      h['X-SourceMap'] = [env['SCRIPT_NAME'], env['PATH_INFO'], '.map'].join
    end
    [s, h, b]
  end
end

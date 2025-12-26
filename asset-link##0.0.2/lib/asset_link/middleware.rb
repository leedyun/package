require 'open-uri'

module AssetLink
  class Middleware
    def initialize(app)
      @app = app
      @manifest = load_manifest
    end

    def call(env)
      request = Rack::Request.new(env)
      code, headers, body = @app.call(env)

      if URI.unescape(request.path).start_with?('/assets/') && code == 200
        entry = body.respond_to?(:to_a) ? body.to_a.first : body

        asset = case entry
                  when Sprockets::Asset
                    entry
                  when Rack::File::Iterator
                    find_asset(entry.path)
                end

        if asset && asset.filename.ends_with?('.link')
          link = File.read(asset.filename).strip # the file contains a link to the actual asset

          open(link) do |f|
            headers = f.meta
            body.close if body.respond_to?(:closed?) && !body.closed?
            body = [f.read]
          end
        end
      end
      [code, headers, body]
    end

    private

    def find_asset(path)
      filename = URI.unescape(path).gsub(/.*\/assets\//, '')

      if @manifest && @manifest['files'][filename]
        manifest_file = @manifest['files'][filename]
        assets_engine.find_asset(manifest_file['logical_path'])
      elsif filename =~ %r{(.*)-[a-z0-9]+\.(.+)}
        assets_engine.find_asset("#{$1}.#{$2}")
      end
    end

    def assets_engine
      @assets_engine ||= Sprockets::Environment.new(Rails.root).tap do |e|
        Dir[Rails.root.join('app', 'assets', '*')].each { |p| e.append_path p }
      end
    end

    def load_manifest
      manifests = Dir[Rails.root.join('public', 'assets', '.sprockets-manifest-*.json')]
      if manifests.first
        file = File.read(manifests.first)
        JSON.parse(file)
      end
    end
  end
end

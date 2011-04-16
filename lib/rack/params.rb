module Rack
  class Params
    URL_ENCODED = %r{^application/x-www-form-urlencoded}
    JSON_ENCODED = %r{^application/json}

    # A middle ware to parse params. This will parse both the
    # query string parameters and the body and place them into
    # the _params_ hash of the Goliath::Env for the request.
    #
    # @example
    #  use Rack::Params
    #
    # -- Borrowed from Goliath -- goliath.io
    
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = retrieve_params(env)
      @app.call(env)
    end

    def retrieve_params(env)
      params = {}
      params.merge!(::Rack::Utils.parse_nested_query(env['QUERY_STRING']))

      if env['rack.input']
        post_params = ::Rack::Utils::Multipart.parse_multipart(env)
        unless post_params
          body = env['rack.input'].read
          env['rack.input'].rewind
          
          post_params = case(env['CONTENT_TYPE'])
          when URL_ENCODED then
            ::Rack::Utils.parse_nested_query(body)
          when JSON_ENCODED then
            JSON.parse(body)
          else
            {}
          end
        end
        params.merge!(post_params)
      end

      params
    end
  end
end

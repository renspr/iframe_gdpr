module IframeGDPR

  class RackMiddleware
    SECURED_IFRAME_PATH = "/_iframe_gdpr"

    def initialize(app, options={})
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.path == SECURED_IFRAME_PATH
        [200, {"Content-Type" => "text/html"}, [render_secured_iframe(request, env)]]
      else
        status, headers, body = @app.call(env)

        if status == 200 && headers['Content-Type'].include?('text/html')
          secure_iframes(request, body)
        end

        [status, headers, body]
      end
    end

  private

    def secure_iframes(request, body)
      iframes = body.body.scan(/<iframe[^>]*?(?:\/>|>[^<]*?<\/iframe>)/)
      iframes.each do |iframe|
        original_src = iframe.match(/src="(.*?)"/)[1] || ""

        service = IframeGDPR.services.find do |service|
          original_src.match(service.src_match)
        end

        if service && request.cookies["iframe_gdpr_#{service.id}"].blank?
          secured_iframe = iframe.gsub(/src=".*?"/, "src=\"#{SECURED_IFRAME_PATH}?service=#{service.id}\" data-original-src=\"#{original_src}\" data-service=\"#{service.id}\"")
          body.body.gsub!(iframe, secured_iframe)
        end
      end
    end

    def render_secured_iframe(request, env)
      renderer = ApplicationController.renderer.new(env)
      service  = IframeGDPR.services.find do |service|
        service.id == request.params["service"].to_sym
      end

      renderer.render(
        template: "iframe_gdpr",
        layout: nil,
        assigns: {
          service: service
        }
      )
    end
  end

end

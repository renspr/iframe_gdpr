module IframeGDPR
  class Engine < ::Rails::Engine
    isolate_namespace IframeGDPR

    config.app_middleware.use(IframeGDPR::RackMiddleware)
  end
end

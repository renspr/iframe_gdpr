require "rails"

module IframeGDPR
  autoload :RackMiddleware, "iframe_gdpr/rack_middleware"
  autoload :Service,        "iframe_gdpr/service"

  mattr_reader :services
  @@services = []

  class << self
    def service(name_or_object)
      service = case name_or_object
      when IframeGDPR::Service
        name_or_object
      when Symbol, String
        use_preconfigured_service(name_or_object.to_sym)
      else
        raise ArgumentError, "Service must be an Iframe::Service instance or a Symbol."
      end

      services << service
    end

    def setup
      yield self
    end

  private

    def use_preconfigured_service(id)
      case id
      when :youtube
        IframeGDPR::Service.new(id).tap do |s|
          s.title     = "YouTube"
          s.src_match = /youtube|youtu.be/
        end
      when :spotify
        IframeGDPR::Service.new(id).tap do |s|
          s.title     = "Spotify"
          s.src_match = /spotify/
        end
      else
        raise ArgumentError, "A preconfigured service with ID '#{id}' doesn't exist."
      end
    end
  end
end

require "iframe_gdpr/engine"

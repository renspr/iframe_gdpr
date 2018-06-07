module IframeGDPR
  class Service

    def initialize(id)
      @id = id.to_sym
    end

    attr_reader   :id
    attr_accessor :title
    attr_accessor :src_match

  end
end

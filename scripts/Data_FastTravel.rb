class FastTravel
  class Zone
    attr_reader :name
    attr_reader :maps
    def initialize(name, maps)
      @name = name
      @maps = maps
    end
  end

  ZONES = {
  }
end

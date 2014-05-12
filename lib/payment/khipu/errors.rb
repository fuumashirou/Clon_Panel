module Khipu
  class Error < StandardError
    attr_reader :origin
    def initialize msg, origin = nil
      super msg
      @origin = origin
    end
  end

  class KhipuError < Error
  end

end

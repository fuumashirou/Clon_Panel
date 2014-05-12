module Khipu
  class Developer < Khipu::Main
    API_VERSION = "1.2"

    def service_url name
      URI.parse "https://khipu.com/api/#{API_VERSION}/#{name}"
    end

  end
end

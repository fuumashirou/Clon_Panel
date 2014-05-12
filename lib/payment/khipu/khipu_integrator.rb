module Khipu
  class Integrator < Khipu::Main
    API_VERSION = "1.2"

    def service_url name
      URI.parse "https://khipu.com/integratorApi/#{API_VERSION}/#{name}"
    end

  end
end

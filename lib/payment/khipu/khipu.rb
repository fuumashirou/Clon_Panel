module Khipu
  class Main
    require "net/http"
    require "net/https"

    NOTIFY_URL = "https://panel.twable.com/payment/notification/khipu"
    attr_accessor :parameters, :uri

    def generate_security_hash params
      string = params.map { |k, v| "#{k}=#{v}" }.join("&")
      hmac   = OpenSSL::HMAC.hexdigest "sha256", Khipu::Receiver.default.secret, string
      return hmac
    end

    def send_request
      hash    = generate_security_hash self.parameters
      https   = Net::HTTP.new self.uri.host, self.uri.port
      request = Net::HTTP::Post.new self.uri.path
      params  = self.parameters.merge(hash: hash).inject({}) { |memo, (k,v)| memo[k.to_s] = v; memo }

      request.set_form_data params
      https.use_ssl = true
      response = https.request request

      if response.code != "200"
        return nil
      else
        if response.content_type == "application/json"
          result = JSON.parse(response.body)
        else
          result = {}
          response.body.split("&").each do |value|
            current = value.split("=")
            unless current.size < 2
              result[current[0]] = current[1]
            end
          end
          return result
        end
      end
    end

    def self.payment_button size
      url = "https://s3.amazonaws.com/static.khipu.com"
      buttons = {
        '50x25'  =>   '/buttons/50x25.png',
        '100x25' =>   '/buttons/100x25.png',
        '100x50' =>   '/buttons/100x50.png',
        '150x25' =>   '/buttons/150x25.png',
        '150x50' =>   '/buttons/150x50.png',
        '150x75' =>   '/buttons/150x75.png',
        '150x75-B' => '/buttons/150x75-B.png',
        '200x50' =>   '/buttons/200x50.png',
        '200x75' =>   '/buttons/200x75.png'
      }

      if buttons[size]
        url + buttons[size] # "<input type='image' name='submit' src='#{url + buttons[size]}'/>"
      else
        false
      end
    end
  end
end

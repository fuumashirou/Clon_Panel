module Khipu
  class Receiver
    attr_reader :id
    attr_reader :secret
    attr_reader :bank

    def initialize attributes
      @id = attributes[:receiver_id]
      raise Khipu::Error, "Missing receiver id" if self.id.nil?
      @secret = attributes[:secret]
      raise Khipu::Error, "Missing secret" if self.secret.nil?
      @bank = attributes[:bank]
      raise Khipu::Error, "Missing bank id" if self.bank.nil?
    end

    def self.default
      @default ||= Receiver.new({
        receiver_id: Khipu.config.receiver_id,
        secret:      Khipu.config.secret,
        bank:        Khipu.config.bank
      }) unless Khipu.config.receiver_id.nil?
    end

    def load_cert
      path = [Rails.root, "config", "cert", Rails.env.production? ? "khipu.pem" : "khipu_dev.pem"].join('/')
      cert = OpenSSL::X509::Certificate.new File.read path
      return cert.public_key
    end

  end
end

module Khipu
  class Config

    def receiver_id(id = nil)
      @id = id if id
      @id || ENV['KHIPU_RECEIVER_ID']
    end

    def secret(secret = nil)
      @secret = secret if secret
      @secret || ENV['KHIPU_SECRET']
    end

    def bank(bank = nil)
      @bank = bank if bank
      @bank || ENV['KHIPU_BANK']
    end

  end

  def self.config
    @config ||= Config.new
  end

  def self.configure(&block)
    yield(self.config)
    nil
  end
end

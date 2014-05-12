# Ver listado de bancos
# body: banks: [{ id, name, message, min-amount }]
module Khipu
  class ReceiverBanks < Khipu::Developer

    attr_accessor :banks
    def initialize options = {}

      receiver = Khipu::Receiver.default
      self.parameters = {
        receiver_id:    receiver.id, # * receiver_id: tu id de cobrador que se encuentra en la sección para desarrolladores.
      }
      self.uri = service_url "receiverBanks"

      result = send_request
      self.banks = result["banks"]
    end

  end
end

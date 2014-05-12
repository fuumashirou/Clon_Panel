# Crear un cobro
# body: receiver_id, secret
module Khipu
  class CreatePaymentUrl < Khipu::Developer

    attr_accessor :id, :url, :mobile_url
    def initialize options = {}
      receiver = Khipu::Receiver.default
      self.parameters = {
        receiver_id:    receiver.id,              # * receiver_id: tu id de cobrador que se encuentra en la sección para desarrolladores.
        subject:        options[:subject],        # * subject: el asunto del cobro. Con un máximo de 255 caracteres.
        body:           options[:body],           # body: la descripción del cobro.
        amount:         options[:amount],         # * amount: el monto del cobro.
        payer_email:    options[:payer_email],    # payer_email: es el correo del pagador. Si lo envias, su correo aparecerá pre-configurado en la página de pago
        bank_id:        receiver.bank,            # bank_id: el código del banco. Puedes obtener los códigos usando la llamada receiverBanks
        transaction_id: options[:transaction_id], # transaction_id: en esta variable puedes enviar un identificador propio de tu transacción, como un número de factura.
        custom:         "",                       # custom: en esta variable puedes enviar información personalizada de la transacción, como por ejemplo, instrucciones de preparación o dirección de envio.
        notify_url:     NOTIFY_URL,               # notify_url: la dirección de tu web service que utilizará khipu para notificarte de un pago realizado. Ver Notificaciones por web service
        return_url:     "",                       # return_url: la dirección URL a donde enviar al cliente cuando el pago está siendo verificado.
        cancel_url:     "",                       # cancel_url: la dirección URL a donde enviar al cliente si se arrepiente de hacer la transacción.
        picture_url:    ""                        # picture_url: una dirección URL de una foto de tu producto o servicio para mostrar en la página del cobro.
      }
      self.uri = service_url "createPaymentURL"

      result = send_request
      self.id = result["id"]
      self.url = result["url"]
      self.mobile_url = result["mobile-url"]
    end

  end
end

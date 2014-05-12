# Verifica un pago
# body:
# api_version: la versión de la API de notificación. (1.0, 1.1 o 1.2)
# receiver_id: el id del cobrador (desde la api_version 1.2).
# subject: el asunto del cobro.
# amount:  el monto total del pago.
# custom:  variable personalizada con datos.
# currency:  el código de la moneda en que se generó el cobro (código único de operación).
# transaction_id:  el identificador de la transacción.
# notification_id: código único generado por khipu para cada pago.
# payer_email: Correo electrónico del pagador (desde la api_version 1.1).
# notification_signature:  firma electrónica de los datos para validar la integridad de los datos.

module Khipu
  class UpdatePaymentNotificationUrl < Khipu::Integrator

    attr_accessor :api_version, :receiver_id, :subject, :amount, :custom, :currency, :transaction_id, :notification_id, :payer_email, :notification_signature
    def initialize
      receiver = Khipu::Receiver.default
      self.parameters = {
        receiver_id: receiver.id, # receiver_id: el id del cobrador
        url:         NOTIFY_URL,  # url: la url en tu sitio para enviar las notificaciones.  opcional
        api_version: API_VERSION  # api_version: la versión de la API de notificaciones
      }
      self.uri = service_url "updatePaymentNotificationUrl"

      result = send_request
      self.api_version = result["api_version"]
      self.receiver_id = result["receiver_id"]
      self.subject = result["subject"]
      self.amount = result["amount"]
      self.custom = result["custom"]
      self.currency = result["currency"]
      self.transaction_id = result["transaction_id"]
      self.notification_id = result["notification_id"]
      self.payer_email = result["payer_email"]
      self.notification_signature = result["notification_signature"]

      return Khipu::VerifyPaymentNotification.local_security_validation(self)
    end

  end
end


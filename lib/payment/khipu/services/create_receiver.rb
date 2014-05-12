# Crear una cuenta de cobro
# body: receiver_id, secret
module Khipu
  class CreateReceiver < Khipu::Integrator

    attr_accessor :receiver_id, :secret
    def initialize options = {}
      receiver = Khipu::Receiver.default
      self.parameters = {
        receiver_id:        receiver.id,                   # * receiver_id: tu id de cobrador que se encuentra en la sección para desarrolladores.
        email:              options[:email],               # * email: Correo electrónico del usuario que será dueño de la nueva cuenta de cobro, si ya existe un usuario en khipu con ese correo electrónico, el cobrador se vinculará a ese usuario.
        first_name:         options[:first_name],          # * first_name: Nombre de pila del usuario que será dueño de la nueva cuenta de cobro
        last_name:          options[:last_name],           # * last_name: Apellido del usuario que será dueño de la nueva cuenta de cobro
        notify_url:         NOTIFY_URL,                    # * notify_url: URL donde se notificarán los pagos efectuados a este cobrador como está descrito en "Validación de pagos".
        identifier:         options[:identifier],          # * identifier: RUT de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        bussiness_category: options[:bussiness_category],  # * bussiness_category: Giro de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        bussiness_name:     options[:bussiness_name],      # * bussiness_name: Nombre o razón social de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        phone:              options[:phone],               # * phone: Teléfono de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        address_line_1:     options[:address_line_1],      # * address_line_1: Dirección comercial de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        address_line_2:     options[:address_line_2],      # * address_line_2: Comuna de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        address_line_3:     options[:address_line_3],      # * address_line_3: Ciudad de la entidad a la que se emitirá la boleta por la comisión khipu de cada pago.
        country_code:       options[:country_code] || "cl" # * country_code: Por ahora debe ser "cl", país de la entidad a la que se emitirá la boleta por la comusión khipu de cada pago.
      }
      self.uri = service_url "createReceiver"

      result = send_request
      self.receiver_id = result["receiver_id"]
      self.secret = result["secret"]
    end

  end
end

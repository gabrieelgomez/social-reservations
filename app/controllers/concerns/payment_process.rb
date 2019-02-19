module PaymentProcess
  extend ActiveSupport::Concern
  
  private

  def payment_gateway
    referencia = params[:referencia]
    respuesta = params[:respuesta]
    if respuesta == 'aprobada'
      invoice = @KT::Invoice.find_by(token: referencia)
      reservation = invoice.reservation
      user = reservation.user
      type = reservation.reservationable_type.split('::').last.downcase.singularize
      invoice.update(status: 'approved')
      ReservationMailer.tour_status(reservation, user).deliver_now if type == 'tour'
      ReservationMailer.transfer_status(reservation, user).deliver_now if type == 'vehicle'
      PaymentMailer.to_user(reservation, user).deliver_now
      PaymentMailer.to_admin(reservation, user).deliver_now
    end
  end

end

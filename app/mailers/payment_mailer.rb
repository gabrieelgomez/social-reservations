class ReservationMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def payment(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Pago Aprobado'
    )
  end

end

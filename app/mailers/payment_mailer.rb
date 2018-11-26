class PaymentMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def to_user(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Pago Completado'
    )
  end

  def to_admin(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: 'reservas@receptivocolombia.com',
      subject: 'Receptivo Colombia - Pago Completado'
    )
  end

end

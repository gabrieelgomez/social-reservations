class DriverMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def transfer_driver(reservation)
    @reservation = reservation
    @travellers  = reservation.travellers
    @invoice     = reservation.invoice
    @driver      = reservation.driver
    mail(
      from: Rails.application.secrets.email,
      to: @driver.user.email,
      subject: "#{@driver.user.name} - Ha sido asignado a un traslado"
    )
  end

end

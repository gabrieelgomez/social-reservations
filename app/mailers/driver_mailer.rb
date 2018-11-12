class DriverMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def transfer_driver(reservation)
    @reservation = reservation
    @travellers  = reservation.travellers
    @invoice     = reservation.invoice
    @driver      = reservation.driver.user
    @vehicle     = reservation.reservationable
    img = @vehicle.cover.url
    @logo = "#{img}"
    attachments.inline[@logo] = File.read("#{Rails.root}/public#{@logo}")
    mail(
      from: Rails.application.secrets.email,
      to: @driver.email,
      subject: "#{@driver.name} - Ha sido asignado a un traslado"
    )
  end

  def transfer_user(reservation)
    @reservation = reservation
    @travellers  = reservation.travellers
    @invoice     = reservation.invoice
    @driver      = reservation.driver.user
    @vehicle     = reservation.reservationable
    img = @vehicle.cover.url
    @logo = "#{img}"
    attachments.inline[@logo] = File.read("#{Rails.root}/public#{@logo}")
    mail(
      from: Rails.application.secrets.email,
      to: @reservation.user.email,
      subject: "#{@driver.name} - Vea más detalles del chofer asignado al traslado"
    )
  end

end

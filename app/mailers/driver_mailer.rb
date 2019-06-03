class DriverMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def transfer_driver_corporative(reservation)
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
      to: [@reservation.driver.email_corporative, @reservation.driver.user.email],
      subject: "#{@driver.name.titleize} - Ha sido asignado a un traslado | Receptivo Colombia"
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
      subject: "Estimado #{@reservation.user.name.titleize} - Vea más detalles del conductor asignado al traslado | Receptivo Colombia"
    )
  end

end

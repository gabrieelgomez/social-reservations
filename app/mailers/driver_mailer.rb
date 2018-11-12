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
      subject: "#{@driver.name} - Ha sido asignado a un traslado | Receptivo Colombia"
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
<<<<<<< HEAD
      to: @driver.email,
      subject: "#{@driver.name} - Vea más detalles del chofer asignado al traslado | Receptivo Colombia"
=======
      to: @reservation.user.email,
      subject: "#{@driver.name} - Vea más detalles del chofer asignado al traslado"
>>>>>>> f663160ca1a8c7fabf1b2de99060fee54a4511fa
    )
  end

end

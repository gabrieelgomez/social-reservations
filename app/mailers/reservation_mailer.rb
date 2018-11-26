class ReservationMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def transfer_status(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Reservación de Traslado'
    )
  end

  def tour_status(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Reservación de Tour'
    )
  end

  def circuit_status(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Reservación de Circuito'
    )
  end

  def to_admin_circuit(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: 'reservas@receptivocolombia.com',
      subject: 'Receptivo Colombia - Reservación de Circuito'
    )
  end


  def multidestination_status(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Reservación de Multidestino'
    )
  end

  def to_admin_multidestination(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: 'reservas@receptivocolombia.com',
      subject: 'Receptivo Colombia - Reservación de Multidestino'
    )
  end

  def send_password(user)
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Registro de Usuario'
    )
  end

end

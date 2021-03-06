class ReservationMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def reservation_status(reservation, user, subject)
    @reservation = reservation
    @user = user

    if user.has_role? :agent
      mail(
        from: Rails.application.secrets.email,
        to: [user.email, user.agent.agency.user.email],
        subject: subject
      )
    else
      mail(
        from: Rails.application.secrets.email,
        to: user.email,
        subject: subject
      )
    end
  end

  def transfer_status(reservation, user)
    @reservation = reservation
    @user = user
    @travellers  = reservation.travellers
    document = @reservation.document.try(:file).try(:url)
    @document = "#{document}"
    attachments.inline[@document] = File.read("#{Rails.root}/public#{@document}") unless @document.blank?
    mail(
      from: Rails.application.secrets.email,
      to: user.email,
      subject: 'Receptivo Colombia - Reservación de Traslado'
    )
  end

  def to_admin_transfer(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: 'reservas@receptivocolombia.com',
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

  def to_admin_tour(reservation, user)
    @reservation = reservation
    @user = user
    mail(
      from: Rails.application.secrets.email,
      to: 'reservas@receptivocolombia.com',
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

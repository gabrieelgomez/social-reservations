module KepplerTravel
  class ReservationMailer < ApplicationMailer
    default from: Rails.application.secrets.email

    def send_password(user)
      @user = user
      mail(
        from: Rails.application.secrets.email,
        to: 'gagg1707@gmail.com',
        subject: 'Receptivo Colombia - Registro de Usuario'
      )
    end
  end
end

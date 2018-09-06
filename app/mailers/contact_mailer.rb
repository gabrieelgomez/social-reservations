class ContactMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def client_contact
    mail(
      # from: mailer_from,
      to: 'gagg1707@gmail.com',
      subject: 'PRUEBA!'
    )

  end

end

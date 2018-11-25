class ContactMailer < ApplicationMailer
  default from: Rails.application.secrets.email

  def to_admin(request)
    @request = request
    mail(
      from: Rails.application.secrets.email,
      to: 'gerencia@receptivocolombia.com',
      subject: "#{@request.name}, enviado un mensaje desde PQRS | Receptivo Colombia"
    )
  end

  def to_user(request)
    @request = request
    mail(
      from: Rails.application.secrets.email,
      to: @request.email,
      subject: "Estimado #{@request.name} - Gracias por su mensaje | Receptivo Colombia"
    )
  end

end

module FrontsHelper

  def url_lang(lang, currency, request, text)
    backlog = request.path.split('/').drop(3).first
    case backlog
    when 'reservations'
        path = request.path.split('/').drop(3).join('/')
      else
        path = backlog
    end
    url = "/#{lang}/#{currency}/#{path}?#{request.query_parameters.to_param}"
    content_tag(
      :a,
      text,
      href: url
    )
  end

end

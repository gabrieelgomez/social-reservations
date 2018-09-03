module FrontsHelper

  def url_lang(lang, currency, request, text)

    path = request.path.split('/').drop(3).first
    url = "/#{lang}/#{currency}/#{path}?#{request.query_parameters.to_param}"
    content_tag(
      :a,
      text,
      href: url
    )
  end

end

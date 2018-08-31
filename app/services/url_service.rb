class UrlService

  def self.build_page(lang, request)
    byebug
    clean_url = request.original_url.sub(/\?.*$/, '')
    parameters_page = request.query_parameters.merge(lang: lang).to_param
    url = clean_url + '?' + parameters_page
  end

  def self.url_lang(lang, currency, request)
    path = request.path.split('/').drop(3).first
    "/#{lang}/#{currency}/#{path}?#{request.query_parameters.to_param}"
  end

end

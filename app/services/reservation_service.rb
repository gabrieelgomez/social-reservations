class ReservationService
  def self.subtotal(params, transfer, lang, currency)
    if params[:round_trip] == 'true'
      "2 x #{transfer.title[lang]} -> 2 x #{transfer.price[currency].to_f}"
    elsif params[:round_trip] == 'false'
      "1 x #{transfer.title[lang]} -> 1 x #{transfer.price[currency].to_f}"
    end
  end

  def self.total(params, transfer, lang, currency)
    if params[:round_trip] == 'true'
      "#{currency.upcase} $ #{transfer.price[currency].to_f * 2}"
    elsif params[:round_trip] == 'false'
      "#{currency.upcase} $ #{transfer.price[currency].to_f}"
    end
  end

end

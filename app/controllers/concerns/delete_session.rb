module DeleteSession
  extend ActiveSupport::Concern

  private

  def delete_session
    session.delete(:reservation)
    session.delete(:user)
    session.delete(:invoice)
    session.delete(:travellers)
    session.delete(:reservationable)
    session.delete(:table_reservationable)
  end

end

module Widget
  extend ActiveSupport::Concern

  private

  def set_search
    @destinations = @KT::Destination.all
    @q = @KT::Vehicle.ransack(params[:q])
  end

  def set_params_widget
    @locality              = [params[:origin_locality], params[:arrival_locality]]
    @departament           = [params[:origin_departament], params[:arrival_departament]]
    @origin_location       = params[:origin_location]
    @origin_name           = params[:origin_name]
    @arrival_location      = params[:arrival_location]
    @arrival_name          = params[:arrival_name]
    @flight_origin_picker  = params[:flight_origin_picker]
    @flight_arrival_picker = params[:flight_arrival_picker]
    @hour_origin_picker    = params[:hour_origin_picker]
    @hour_arrival_picker   = params[:hour_arrival_picker]
    @round_trip            = params[:round_trip]
    @adults                = params[:quantity_adults].to_i
    @kids                  = params[:quantity_kids].to_i
    @seats                 = @adults + @kids
    @flight_origin_tour_picker    = params[:flight_origin_tour_picker] || params[:flight_tour_data]
    @flight_origin_circuit_picker = params[:flight_origin_circuit_picker] || params[:flight_circuit_data]
    @flight_origin_multidestination_picker = params[:flight_origin_multidestination_picker] || params[:flight_multidestination_data]
  end

end

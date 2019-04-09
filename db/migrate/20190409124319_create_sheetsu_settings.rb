class CreateSheetsuSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :sheetsu_settings do |t|

      t.string  :sheetsu_url_drivers
      t.string  :sheetsu_code_drivers
      t.string  :sheetsu_spreadsheet_drivers

      t.string  :sheetsu_url_vehicles
      t.string  :sheetsu_code_vehicles
      t.string  :sheetsu_spreadsheet_vehicles

      t.string  :sheetsu_url_tours
      t.string  :sheetsu_code_tours
      t.string  :sheetsu_spreadsheet_tours

      t.string  :sheetsu_url_circuits
      t.string  :sheetsu_code_circuits
      t.string  :sheetsu_spreadsheet_circuits

      t.string  :sheetsu_url_multidestinations
      t.string  :sheetsu_code_multidestinations
      t.string  :sheetsu_spreadsheet_multidestinations

      t.string  :sheetsu_url_destinations
      t.string  :sheetsu_code_destinations
      t.string  :sheetsu_spreadsheet_destinations

      t.string  :sheetsu_url_lodgments
      t.string  :sheetsu_code_lodgments
      t.string  :sheetsu_spreadsheet_lodgments

      t.integer :setting_id

      t.timestamps
    end
  end
end

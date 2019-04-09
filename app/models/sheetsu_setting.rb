class SheetsuSetting < ApplicationRecord
  belongs_to :setting
  # SheetsuSetting.create(sheetsu_url_tours: 'test', setting_id: 1)
end

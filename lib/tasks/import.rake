require 'roo'

namespace :import do
  desc "import filters"
  task filters: :environment do
    url = "https://docs.google.com/spreadsheets/d/1xNJ5sM7II2PThPymmlIwSvJ2pB8pP7o55fnio9Tw618/export?format=xlsx"
    child = nil
    xlsx = Roo::Spreadsheet.open(url, extension: :xlsx)
    xlsx.sheets.each do |name|
      sheet = xlsx.sheet(name)
      parent = Filter.find_or_create_by(name: name, max_levels_allowed: sheet.last_column)
      sheet.last_row.times do |i|
        child = parent.sub_filters.find_or_create_by(name: sheet.cell(i + 1, 1).gsub("\n", ''), max_levels_allowed: sheet.last_column - 1) if sheet.cell(i + 1, 1).present?
        child.sub_filters.find_or_create_by(name: sheet.cell(i + 1, 2).gsub("\n", ''), max_levels_allowed: 0) if sheet.last_column == 2 && sheet.cell(i + 1, 2).present?
      end
    end
  end
end

require 'spreadsheet'
require 'date'

class MainService
  def initialize(internal_source_file_path, external_source_file_path)
    Spreadsheet.client_encoding = 'UTF-8'

    @internal_source_file = Spreadsheet.open internal_source_file_path
    @internal_source_file_worksheet = @internal_source_file.worksheet 0

    @external_source_file = Spreadsheet.open external_source_file_path
    @external_source_file_worksheet = @external_source_file.worksheet 0

    @inclusion_file = Spreadsheet::Worksheet.new
    @inclusion_file_worksheet = @inclusion_file.create_worksheet
    @inclusion_file_index = 1

    @exclusion_file = Spreadsheet::Worksheet.new
    @exclusion_file_worksheet = @exclusion_file.create_worksheet
    @exclusion_file_index = 1
  end

  def run
    @external_source_file_worksheet.each do |external_row, index|
      next if index == 0
      id = external_row[1]

      # search in internal file
      found = search_in_worksheet(@internal_source_file_worksheet, id)

      write_on_inclusion_file(external_row) unless found
    end
  end

  def search_in_worksheet(worksheet, id_to_search)
    found = false

    worksheet.each do |row|
      if row.includes? id_to_search
        found = true
        break
      end
    end

    found
  end

  def write_on_exclusion_file(row)
    # we just need government_id_type and government_id
    @exclusion_file_worksheet.row(@exclusion_file_index).concat([row[0], row[1]])
    @exclusion_file_index += 1
  end

  def write_on_inclusion_file(row)
    @inclusion_file_worksheet.row(@inclusion_file_index).concat(row)
    @inclusion_file_index += 1
  end

  def inclusion_file_headers
    [
      'government_id_type',
      'government_id',
      'country_of_birth',
      'birthday',
      'gender',
      'first_name',
      'second_first_name',
      'last_name',
      'second_last_name',
      'email',
      'phone',
      'province',
      'canton',
      'district',
      'company'
    ]
  end

  def exclusion_file_headers
    [
      'government_id_type',
      'government_id',
    ]
  end

  def file_name(type: 'inclusion')
    "affiliates_#{type == 'inclusion'? 'inclusion' : 'exclusion'}_#{Date.today}.xls"
  end
end
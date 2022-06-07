# frozen_string_literal: true

require './services/arguments_parser_service'
require './services/main_service'

response = ArgumentsParserService.new(ARGV).run

if response[:error]
  puts response[:message]

  exit(false)
end

puts 'Processing files...'

MainService.new(response[:internal_source_file], response[:external_source_file]).run

puts 'OK'

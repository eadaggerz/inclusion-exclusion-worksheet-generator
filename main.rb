require './services/arguments_parser_service'

response = ArgumentsParserService.new(ARGV).run

if response[:error]
  puts response[:message]

  exit(false)
end
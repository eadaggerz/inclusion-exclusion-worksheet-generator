class ArgumentsParserService
  def initialize(args)
    @args = args
  end

  def run
    return { error: true, message: wrong_number_of_arguments_message } if wrong_number_of_arguments

    internal_source_file = @args[0]

    return { error: true, message: file_error_message(internal_source_file) } unless file_exists?(internal_source_file)

    external_source_file = @args[1]

    return { error: true, message: file_error_message(external_source_file) } unless file_exists?(external_source_file)

    return { error: false, internal_source_file: internal_source_file, external_source_file: external_source_file }
  end

  def wrong_number_of_arguments
    @args.length != 2
  end

  def wrong_number_of_arguments_message
    "Wrong number of arguments. Expected 2, given #{@args.length}."
  end

  def file_exists?(file_location)
    File.exist? file_location
  end

  def file_error_message(file_location)
    "Error file #{file_location} not found."
  end

end
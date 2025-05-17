#!/usr/bin/env ruby

require 'json'
require 'bson'
require 'cbor'
require 'optparse'

# Parse command line options
options = {format: 'bson'}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} -f FORMAT input.json output_file"
  
  opts.on("-f", "--format FORMAT", "Output format (bson or cbor)") do |format|
    unless ['bson', 'cbor'].include?(format.downcase)
      puts "Error: Format must be either 'bson' or 'cbor'"
      exit 64
    end
    options[:format] = format.downcase
  end
  
  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end

begin
  parser.parse!
  
  # Check if filenames were provided as command line arguments
  if ARGV.length != 2
    puts parser
    exit 64
  end
  
  input_file = ARGV[0]
  output_file = ARGV[1]
  
  # Check if input file exists
  unless File.exist?(input_file)
    puts "Error: Input file '#{input_file}' does not exist."
    exit 64
  end
  
  # Read and parse the JSON file
  json_data = File.read(input_file)
  ruby_obj = JSON.parse(json_data)
  
  # Convert and write based on the selected format
  data = case options[:format]
  when 'bson'
    BSON::Document.new(ruby_obj).to_bson
  when 'cbor'
    ruby_obj.to_cbor
  end

  # Write the data to the output file
  File.open(output_file, 'wb') do |file|
    file.write(data)
  end
  puts "Successfully converted #{input_file} to #{options[:format]} format at #{output_file}"
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts "Error: #{e.message}"
  puts parser
  exit 64
rescue JSON::ParserError => e
  puts "Error parsing JSON: #{e.message}"
  exit Errno::EINVAL
rescue Errno::ENOENT => e
  puts "Error: #{e.message}"
  exit Errno::ENOENT
rescue Errno::EACCES => e
  puts "Error: Permission denied when accessing a file: #{e.message}"
  exit Errno::EACCESS
rescue => e
  puts "Error: #{e.message}"
  exit 1
end

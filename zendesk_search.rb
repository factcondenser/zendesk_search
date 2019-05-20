#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require './zd_search_engine'

options = {}

OptionParser.new do |parser|
  parser.banner = 'Usage: ./zendesk_search.rb [options]'

  parser.on('-h', '--help', 'Show this help message') do
    puts parser
    exit
  end

  parser.on('--environment ENV', 'The environment in which to run the search engine') do |v|
    options[:env] = v
  end
end.parse!

ZdSearchEngine.new(env: options[:env]).run

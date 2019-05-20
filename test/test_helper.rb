# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'

FIXTURES_PATH = 'test/fixtures'

def run_with_input(filename)
  `cat #{FIXTURES_PATH}/#{filename} | ruby zendesk_search.rb --environment test`
end

def decolorize(string)
  string.gsub(/\e\[(\d+)m/, '')
end

def remove_trailing_white_space_after_colons(string)
  string.gsub(/:\s+$/m, ':')
end

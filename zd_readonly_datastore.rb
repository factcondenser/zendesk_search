# frozen_string_literal: true

# This class retrieves, caches, and reads data from JSON files /
# located in the same directory as itself.
class ZdReadonlyDatastore
  require 'json'

  def initialize
    @data = {}
  end

  # Assumes `category` matches the name of a co-located JSON file.
  # e.g. 'users' category matches 'users.json'.
  def find_all(category, key, value)
    @data[category] ||= extract_hashes_from_json_file("#{category}.json")
    @data[category].select { |hsh| hsh.key?(key) && hsh[key].to_s == value }
  end

  # Assumes all hashes extracted from the JSON file for the /
  # given category have the same keys.
  def searchable_fields_for(category)
    @data[category] ||= extract_hashes_from_json_file("#{category}.json")
    @data[category].first.keys
  end

  private

  # Assumes `file_name` is the name of a JSON file that contains /
  # a single JSON Array that contains at least one JSON Object.
  def extract_hashes_from_json_file(file_name)
    JSON.parse(File.read(file_name))
  end
end

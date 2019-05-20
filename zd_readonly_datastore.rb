# frozen_string_literal: true

# This class retrieves, caches, and reads data from JSON files /
# located in the same directory as itself.
class ZdReadonlyDatastore
  require 'json'

  def initialize(env: 'prod')
    @env = env
    @data = {}
  end

  # Assumes `category` matches the name of a JSON file in the /
  # db folder (e.g. 'users' category matches 'db/users.json').
  def find_all(category, key, value)
    db_path = @env == 'test' ? 'test/db' : 'db'
    @data[category] ||= extract_hashes_from_json_file("#{db_path}/#{category}.json")
    @data[category].select { |hsh| hsh.key?(key) && hsh[key].to_s == value }
  end

  # Assumes all hashes extracted from the JSON file for the /
  # given category have the same keys.
  def searchable_fields_for(category)
    db_path = @env == 'test' ? 'test/db' : 'db'
    @data[category] ||= extract_hashes_from_json_file("#{db_path}/#{category}.json")
    @data[category].first.keys
  end

  private

  # Assumes `file_name` is the name of a JSON file that contains /
  # a single JSON Array that contains at least one JSON Object.
  def extract_hashes_from_json_file(file_name)
    File.exist?(file_name) ? JSON.parse(File.read(file_name)) : [{}]
  end
end

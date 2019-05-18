# frozen_string_literal: true

ZdSearchEngine.new.run

class ZdSearchEngine
  QUIT = %w[q quit].freeze

  def initialize
    @datastore = ZdReadonlyDatastore.new
  end

  def run
    ZdSearchConsole.notify_start
    loop do
      user_input = ZdSearchConsole.prompt_main
      case user_input
      when QUIT
        ZdSearchConsole.notify_quit
        exit(0)
      when ZdSearchPolicy.valid_inputs_for_context('main')
        send(ZdSearchPolicy.parse_input_for_context(user_input, 'main'))
      else
        ZdSearchConsole.notify_invalid_input(user_input)
      end
    end
  end

  private

  def search
    user_input = ZdSearchConsole.prompt_categories(ZdSearchPolicy.valid_search_categories)
    case user_input
    when QUIT
      ZdSearchConsole.notify_quit
      exit(0)
    when ZdSearchPolicy.valid_inputs_for_context('categories')
      category = ZdSearchPolicy.parse_input_for_context(user_input, 'categories')
      field, value = ZdSearchConsole.prompt_search
      results = @datastore.find_all(category, field, value)
      ZdSearchConsole.notify_search_results(results, category, field, value)
    else
      ZdSearchConsole.notify_invalid_input(user_input)
    end
  end

  def list_Fields
    user_input = ZdSearchConsole.prompt_categories(ZdSearchPolicy.valid_search_categories)
    case user_input
    when QUIT
      ZdSearchConsole.notify_quit
      exit(0)
    when ZdSearchPolicy.valid_inputs_for_context('categories')
      category = ZdSearchPolicy.parse_input_for_context(user_input, 'categories')
      results = @datastore.searchable_fields_for(category)
      ZdSearchConsole.notify_list_fields_results(results, category)
    else
      ZdSearchConsole.notify_invalid_input(user_input)
    end
  end
end

class ZdReadonlyDatastore
  def initialize
    @categories = {}
  end

  def find_all(category, key, value)
    @categories[category] ||= extract_structs_from_json_file(category, "#{category.downcase}.json")
    @categories[category].select { |obj| obj.send(key) == value }
  end

  def searchable_fields_for(category)
    @categories[category] ||= extract_structs_from_json_file(category, "#{category.downcase}.json")
    @categories[category].first.members
  end

  private

  # Assumes file_name is the name of a JSON file that contains /
  # a single JSON Array that contains at least one JSON Object.
  def extract_structs_from_json_file(struct_name, file_name)
    attr_hashes = JSON.parse(File.read(file_name), symbolize_names: true)
    available_attrs = attr_hashes.flat_map(&:keys).uniq
    Object.const_set(struct_name, Struct.new(*available_attrs, keyword_init: true))
    struct_const = Object.const_get(struct_name)
    attr_hashes.map { |hsh| struct_const.new(hsh) }
  end
end

module ZdSearchConsole
  def self.notify_start
    puts 'Welcome to Zendesk Search'
    puts "Type 'q' or quit' to exit at any time. Press 'Enter' to continue."
  end

  def self.prompt_main
    puts
    puts
    puts '        Select search options:'
    puts '         * Press 1 to search Zendesk'
    puts '         * Press 2 to view a list of searchable fields'
    puts "         * Type 'q' or 'quit' to exit"
    puts
    gets.strip
  end

  def self.prompt_categories(categories)
    options = []
    categories.each_with_index do |category, i|
      options << "#{i + 1}) #{category}"
    end
    puts "Select #{options.join(' or ')}"
    gets.strip
  end

  def self.prompt_search
    print 'Enter name of field to search on: '
    field = gets.strip
    print "Enter search value. To search for empty values, just press 'Enter':"
    value = gets.strip
    [field, value]
  end

  def self.notify_invalid_input(input)
    puts "        '#{input}' is an invalid option. Please try again."
  end

  def self.notify_quit
    puts 'Thank you for using Zendesk Search'
  end

  def self.notify_search_results(results, category, field, value)
    if results.length == 0
      puts "No #{category} found with '#{field}' equal to '#{value}'"
    else
      puts "Displaying #{results.length} #{category} with '#{field}' equal to '#{value}'"
      results.each do |obj|
        puts ''
        obj.each do |k, v|
          puts "#{k}: #{v}"
        end
      end
    end
  end

  def self.notif_list_fields_results(results, category)
    if results.length == 0
      puts "No searchable fields found for #{category}"
    else
      puts "Displaying all searchable fields for #{category}"
      results.each do |field|
        puts field
      end
    end
  end
end

module ZdSearchPolicy
  INPUT_MAP = {
    'main' => {
      '1' => 'search',
      '2' => 'list_fields'
    },
    'categories' => {
      '1' => 'Users',
      '2' => 'Tickets',
      '3' => 'Organizations'
    }
  }.freeze

  def self.valid_search_categories
    INPUT_MAP['categories'].values
  end

  def self.valid_inputs_for_context(context)
    INPUT_MAP[context].keys
  end

  def self.parse_input_for_context(input, context)
    INPUT_MAP.dig(context, input)
  end
end

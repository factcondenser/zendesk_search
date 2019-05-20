# frozen_string_literal: true

require './zd_search_console'
require './zd_readonly_datastore'
require './zd_search_policy'

# This class coordinates the work performed by the ZdSearchConsole module and /
# the ZdReadonlyDatastore class. It defers to ZdSearchPolicy for mapping user /
# inputs to commands it understands.
class ZdSearchEngine
  def initialize(env: 'prod')
    @datastore = ZdReadonlyDatastore.new(env: env)
  end

  def run
    ZdSearchConsole.notify_start(ZdSearchPolicy.quit_options)
    loop do
      user_input = ZdSearchConsole.prompt_main
      handle_input_for_context(user_input, 'main') do |parsed_input|
        send(parsed_input)
      end
    end
  end

  private

  def search
    waiting_for_parsed_input = true
    while waiting_for_parsed_input
      user_input = ZdSearchConsole.prompt_categories(ZdSearchPolicy.valid_search_categories)
      handle_input_for_context(user_input, 'categories') do |parsed_input|
        waiting_for_parsed_input = false
        category = parsed_input
        field, value = ZdSearchConsole.prompt_search
        results = @datastore.find_all(category, field, value)
        ZdSearchConsole.notify_search_results(results, category, field, value)
      end
    end
  end

  def list_fields
    waiting_for_parsed_input = true
    while waiting_for_parsed_input
      user_input = ZdSearchConsole.prompt_categories(ZdSearchPolicy.valid_search_categories)
      handle_input_for_context(user_input, 'categories') do |parsed_input|
        waiting_for_parsed_input = false
        category = parsed_input
        results = @datastore.searchable_fields_for(category)
        ZdSearchConsole.notify_list_fields_results(results, category)
      end
    end
  end

  def handle_input_for_context(input, context)
    if ZdSearchPolicy.quit_options.include?(input)
      ZdSearchConsole.notify_quit
      exit
    end

    if (parsed_input = ZdSearchPolicy.parse_input_for_context(input, context))
      yield(parsed_input)
    else
      ZdSearchConsole.notify_invalid_input(input)
    end
  end
end

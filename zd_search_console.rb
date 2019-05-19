# frozen_string_literal: true

require 'readline'

# This module displays Zendesk Search prompts and notifications.
# All prompt methods return user input.
module ZdSearchConsole
  class << self
    def notify_start(quit_options)
      puts 'Welcome to Zendesk Search'
      puts "Type '#{quit_options.join(' or ')}' to exit at any time"
    end

    def prompt_main
      puts
      puts
      puts '        Select search options:'
      puts '         * Press 1 to search Zendesk'
      puts '         * Press 2 to view a list of searchable fields'
      puts "         * Type 'q' or 'quit' to exit"
      puts

      obtain_input do
        Readline.readline('> ', true).strip
      end
    end

    def prompt_categories(categories)
      options = []
      categories.each_with_index do |category, i|
        options << "#{i + 1}) #{category.capitalize}"
      end
      puts "Select #{options.join(' or ')}"

      obtain_input do
        Readline.readline('> ', true).strip
      end
    end

    def prompt_search
      obtain_input do
        field = Readline.readline('Enter name of field to search on: ', true).strip
        value = Readline.readline("Enter search value. To search for empty values, just press 'Enter': ", true).strip
        [field, value]
      end
    end

    def notify_invalid_input(input)
      puts "        '#{input}' is an invalid option. Please try again."
    end

    def notify_quit
      puts 'Thank you for using Zendesk Search'
    end

    def notify_search_results(results, category, field, value)
      if results.length.zero?
        puts "No #{category.capitalize} found with '#{field}' equal to '#{value}'"
      else
        puts "Displaying #{results.length} result(s) for #{category.capitalize} with '#{field}' equal to '#{value}'"
        results.each do |hsh|
          puts ''
          hsh.each do |k, v|
            puts "#{k}: #{v}"
          end
        end
      end
    end

    def notify_list_fields_results(results, category)
      if results.length.zero?
        puts "No searchable fields found for #{category.capitalize}"
      else
        puts "Displaying all searchable fields for #{category.capitalize}"
        results.each do |field|
          puts field
        end
      end
    end

    private

    def obtain_input
      stty_save = `stty -g`.chomp # Save terminal state

      begin
        yield
      rescue Interrupt => _e
        system('stty', stty_save) # Restore
        exit
      end
    end
  end
end

# frozen_string_literal: true

require './string_extensions'
require 'readline'

# This module displays Zendesk Search prompts and notifications.
# All prompt methods return user input.
module ZdSearchConsole
  using StringExtensions

  class << self
    def notify_start(quit_options)
      puts 'Welcome to Zendesk Search!'.bold.green
      puts "Type '#{quit_options.join('\' or \'')}' to exit at any time".bold
    end

    def prompt_main
      puts
      puts '========== SEARCH OPTIONS =========='
      puts '1) Search Zendesk'
      puts '2) View a list of searchable fields'
      puts

      obtain_input do
        Readline.readline('Please enter your choice: ', true).strip
      end
    end

    def prompt_categories(categories)
      puts
      puts '========== PICK A CATEGORY =========='
      categories.each_with_index do |category, i|
        puts "#{i + 1}) #{category.capitalize}"
      end
      puts

      obtain_input do
        Readline.readline('Please enter your choice: ', true).strip
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
      puts "'#{input}' is an invalid option. Please try again.".bold.yellow
    end

    def notify_quit
      puts 'Thank you for using Zendesk Search!'.bold.green
    end

    def notify_search_results(results, category, field, value)
      puts
      if results.length.zero?
        puts "No #{category.capitalize} found with '#{field}' equal to '#{value}'".bold.light_blue
      else
        puts "Displaying #{results.length} result(s) for #{category.capitalize} with '#{field}' equal to '#{value}':".bold.light_blue
        col_width = results.first.keys.map(&:length).max
        results.each do |hsh|
          hsh.each do |k, v|
            # pair = "#{k.to_s.rjust(col_width)}: #{v}"
            pair = "#{k}: ".ljust(col_width + 2) + v.to_s
            puts k == field ? pair.bold : pair
          end
          puts '-' * 40
        end
        puts "End of #{results.length} result(s)".bold.light_blue
      end
    end

    def notify_list_fields_results(results, category)
      puts
      if results.length.zero?
        puts "No searchable fields found for #{category.capitalize}".bold.light_blue
      else
        puts "Displaying all searchable fields for #{category.capitalize}:".bold.light_blue
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
        puts
        notify_quit
        exit
      end
    end
  end
end

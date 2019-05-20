# frozen_string_literal: true

require_relative './test_helper'
require_relative '../zd_search_console'

describe ZdSearchConsole do
  subject { ZdSearchConsole }

  describe '::notify_start' do
    it 'displays a welcome message with quit options' do
      expected_output = <<~HEREDOC
        Welcome to Zendesk Search!
        Type 'foo' or 'bar' to exit at any time
      HEREDOC
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_start(%w[foo bar])"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end
  end

  describe '::prompt_main' do
    it 'displays the main prompt' do
      expected_output = <<~HEREDOC
        Please enter your choice: q

        ========== SEARCH OPTIONS ==========
        1) Search Zendesk
        2) View a list of searchable fields

      HEREDOC
      actual_output = `echo q | ruby -e "require './zd_search_console'; #{subject}.prompt_main"`
      assert_equal expected_output, actual_output
    end
  end

  describe '::prompt_categories' do
    it 'displays the categories prompt' do
      expected_output = <<~HEREDOC
        Please enter your choice: q

        ========== PICK A CATEGORY ==========
        1) Lemurs
        2) Pencils
        3) Cities
        4) Ice_cream_flavors

      HEREDOC
      actual_output = `echo q | ruby -e "require './zd_search_console'; #{subject}.prompt_categories(%w[lemurs pencils cities ice_cream_flavors])"`
      assert_equal expected_output, actual_output
    end
  end

  describe '::prompt_search' do
    it 'displays the categories prompt' do
      expected_output = <<~HEREDOC
        Enter name of field to search on: status
        Enter search value. To search for empty values, just press 'Enter': awesome
      HEREDOC
      actual_output = `printf "status\nawesome" | ruby -e "require './zd_search_console'; #{subject}.prompt_search"`
      assert_equal expected_output, actual_output
    end
  end

  describe '::notify_invalid_input' do
    it 'displays invalid input notification with specified input' do
      expected_output = "'cheesecake' is an invalid option. Please try again.\n"
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_invalid_input('cheesecake')"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end
  end

  describe '::notify_quit' do
    it 'displays a thank you message' do
      expected_output = "Thank you for using Zendesk Search!\n"
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_quit"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end
  end

  describe '::notify_search_results' do
    it 'displays the given results' do
      expected_output = <<~HEREDOC

        Displaying 2 result(s) for People with 'name' equal to 'Bob':
        name:  Bob
        roles: ["builder", "friend"]
        ----------------------------------------
        name:  Bob
        roles: ["cryptography textbook example"]
        ----------------------------------------
        End of 2 result(s)
      HEREDOC
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_search_results([{name: 'Bob', roles: %w[builder friend]}, {name: 'Bob', roles: ['cryptography textbook example']}], 'people', 'name', 'Bob')"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end

    it "displays a 'none found' message if results is empty" do
      expected_output = "\nNo People found with 'name' equal to 'Frodo'\n"
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_search_results([], 'people', 'name', 'Frodo')"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end
  end

  describe '::notify_list_fields_results' do
    it 'displays the given results' do
      expected_output = <<~HEREDOC

        Displaying all searchable fields for Example_category:
        these
        are
        fields
        that
        can
        be
        searched
        on
      HEREDOC
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_list_fields_results(%w[these are fields that can be searched on], 'example_category')"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end

    it "displays a 'none found' message if results is empty" do
      expected_output = "\nNo searchable fields found for Puppies\n"
      actual_output = `ruby -e "require './zd_search_console'; #{subject}.notify_list_fields_results([], 'puppies')"`
      actual_output = decolorize(actual_output)
      assert_equal expected_output, actual_output
    end
  end
end

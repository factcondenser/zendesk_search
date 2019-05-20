# frozen_string_literal: true

require_relative './test_helper'

describe 'zendesk_search.rb script' do
  it "exits if the user types out 'quit'" do
    expected_output = File.read("#{FIXTURES_PATH}/quit_output.txt")
    actual_output = run_with_input('quit_input.txt')
    actual_output = decolorize(actual_output)
    assert_equal expected_output, actual_output
  end

  it "displays 'try again' message if search option is invalid" do
    expected_output = File.read("#{FIXTURES_PATH}/invalid_search_option_output.txt")
    actual_output = run_with_input('invalid_search_option_input.txt')
    actual_output = decolorize(actual_output)
    assert_equal expected_output, actual_output
  end

  it 'displays searchable fields for a selected category' do
    expected_output = File.read("#{FIXTURES_PATH}/list_fields_for_users_output.txt")
    actual_output = run_with_input('list_fields_for_users_input.txt')
    actual_output = decolorize(actual_output)
    assert_equal expected_output, actual_output
  end

  it "displays 'try again' message if searchable fields category is invalid" do
    expected_output = File.read("#{FIXTURES_PATH}/list_fields_for_invalid_category_output.txt")
    actual_output = run_with_input('list_fields_for_invalid_category_input.txt')
    actual_output = decolorize(actual_output)
    assert_equal expected_output, actual_output
  end

  it 'displays all matching objects for a selected category, field, and value' do
    expected_output = File.read("#{FIXTURES_PATH}/search_tickets_where_type_equals_problem_output.txt")
    actual_output = run_with_input('search_tickets_where_type_equals_problem_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end

  it "displays 'try again' message if search category is invalid" do
    expected_output = File.read("#{FIXTURES_PATH}/search_invalid_category_output.txt")
    actual_output = run_with_input('search_invalid_category_input.txt')
    actual_output = decolorize(actual_output)
    assert_equal expected_output, actual_output
  end

  it 'displays no search results for a non-existent field' do
    expected_output = File.read("#{FIXTURES_PATH}/search_tickets_where_field_does_not_exist_output.txt")
    actual_output = run_with_input('search_tickets_where_field_does_not_exist_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end

  it 'displays no search results for an empty field' do
    expected_output = File.read("#{FIXTURES_PATH}/search_tickets_where_field_is_empty_output.txt")
    actual_output = run_with_input('search_tickets_where_field_is_empty_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end

  it 'displays no search results for a non-existent value' do
    expected_output = File.read("#{FIXTURES_PATH}/search_tickets_where_type_equals_gobbledygook_output.txt")
    actual_output = run_with_input('search_tickets_where_type_equals_gobbledygook_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end

  it 'allows searching by empty value' do
    expected_output = File.read("#{FIXTURES_PATH}/search_tickets_where_description_is_empty_output.txt")
    actual_output = run_with_input('search_tickets_where_description_is_empty_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end

  it 'allows searching by a field that has an array as its value' do
    expected_output = File.read("#{FIXTURES_PATH}/search_users_by_tags_field_output.txt")
    actual_output = run_with_input('search_users_by_tags_field_input.txt')
    actual_output = remove_trailing_white_space_after_colons(decolorize(actual_output))
    assert_equal expected_output, actual_output
  end
end

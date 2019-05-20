# frozen_string_literal: true

require_relative './test_helper'
require_relative '../zd_search_policy'

describe ZdSearchPolicy do
  subject { ZdSearchPolicy }

  describe '::quit_options' do
    it 'returns an array of quit options' do
      assert_equal %w[q quit], subject.quit_options
    end
  end

  describe '::valid_search_categories' do
    it 'returns an array of searchable categories' do
      assert_equal %w[users tickets organizations], subject.valid_search_categories
    end
  end

  describe '::parse_input_for_context' do
    it "converts user input for the 'main' context" do
      assert_equal 'list_fields', subject.parse_input_for_context('2', 'main')
    end

    it "converts user input for the 'categories' context" do
      assert_equal 'organizations', subject.parse_input_for_context('3', 'categories')
    end

    it 'returns nil if given context is invalid' do
      assert_nil subject.parse_input_for_context('2', 'not_a_real_context')
    end

    it 'returns nil if given user input is invalid' do
      assert_nil subject.parse_input_for_context('xkpq', 'categories')
    end
  end
end

# frozen_string_literal: true

require_relative './test_helper'
require_relative '../zd_readonly_datastore'

describe ZdReadonlyDatastore do
  subject { ZdReadonlyDatastore.new }

  describe '#find_all' do
    it 'returns all matching objects' do
      expected_results = JSON.parse(File.read("#{FIXTURES_PATH}/objects_where_type_equals_b.json"))
      actual_results = subject.find_all("#{FIXTURES_PATH}/test_objects", 'type', 'B')
      assert expected_results, actual_results
    end
  end

  describe '#searchable_fields_for' do
    it 'returns searchable fields for given category' do
      expected_results = %w[_id name description aliases type]
      actual_results = subject.searchable_fields_for("#{FIXTURES_PATH}/test_objects")
      assert expected_results, actual_results
    end
  end
end

# frozen_string_literal: true

require_relative './test_helper'
require_relative '../zd_readonly_datastore'

describe ZdReadonlyDatastore do
  subject { ZdReadonlyDatastore.new(env: 'test') }

  describe '#find_all' do
    it 'returns all matching objects' do
      expected_results = JSON.parse(File.read("#{FIXTURES_PATH}/organizations_where_details_equals_megacorp.json"))
      actual_results = subject.find_all('organizations', 'details', 'MegaCorp')
      assert_equal expected_results, actual_results
    end

    it 'returns empty array if category does not exist' do
      assert_equal [], subject.find_all('not_a_real_category', 'details', 'MegaCorp')
    end

    it 'returns empty array if field does not exist' do
      assert_equal [], subject.find_all('organizations', 'not_a_real_field', 'MegaCorp')
    end

    it 'returns empty array if value does not exist' do
      assert_equal [], subject.find_all('organizations', 'details', 'Totally made-up details')
    end
  end

  describe '#searchable_fields_for' do
    it 'returns searchable fields for given category' do
      expected_results = %w[_id url external_id name domain_names created_at details shared_tickets tags]
      actual_results = subject.searchable_fields_for('organizations')
      assert_equal expected_results, actual_results
    end

    it 'returns empty array if category does not exist' do
      assert_equal [], subject.searchable_fields_for('not_a_real_category')
    end
  end
end

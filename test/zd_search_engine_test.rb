# frozen_string_literal: true

require_relative './test_helper'
require_relative '../zd_search_engine'

describe ZdSearchEngine do
  subject { ZdSearchEngine.new(env: 'test') }

  it 'initializes readonly datastore' do
  end

  it 'makes calls to ZdSearchConsole and ZdSearchPolicy' do
  end
end

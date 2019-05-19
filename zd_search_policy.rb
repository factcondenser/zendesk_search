# frozen_string_literal: true

# This module stores Zendesk Search inputs and their mappings.
module ZdSearchPolicy
  INPUT_MAP = {
    'main' => {
      '1' => 'search',
      '2' => 'list_fields'
    },
    'categories' => {
      '1' => 'users',
      '2' => 'tickets',
      '3' => 'organizations'
    }
  }.freeze
  QUIT = %w[q quit].freeze

  def self.quit_options
    QUIT
  end

  def self.valid_search_categories
    INPUT_MAP['categories'].values
  end

  def self.parse_input_for_context(input, context)
    INPUT_MAP.dig(context, input)
  end
end

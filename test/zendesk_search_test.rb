require 'test_helper'
require 'zendesk_search'

describe 'zendesk_search.rb script' do
  it 'outputs a report to stdout given input via stdin' do
    expected = File.read('spec/fixtures/files/test_output.txt')
    actual = `cat spec/fixtures/files/test_input.txt | ruby main_script.rb`
    expect(actual).to eq(expected)
  end

  it 'outputs a report to stdout given input via stdin' do
    expected = File.read('spec/fixtures/files/test_output.txt')
    actual = `cat spec/fixtures/files/test_input.txt | ruby main_script.rb`
    expect(actual).to eq(expected)
  end

  it 'outputs a report to stdout given input via stdin' do
    expected = File.read('spec/fixtures/files/test_output.txt')
    actual = `cat spec/fixtures/files/test_input.txt | ruby main_script.rb`
    expect(actual).to eq(expected)
  end
  
  it 'outputs a report to stdout given input via stdin' do
    expected = File.read('spec/fixtures/files/test_output.txt')
    actual = `cat spec/fixtures/files/test_input.txt | ruby main_script.rb`
    expect(actual).to eq(expected)
  end
end
require 'spec_helper'

describe PatternCounter do
  WORD_REGEX = /[\p{Alpha}\-']+/

  before(:all) do
    words = 'This is this and that is that.'
    @word_counter = PatternCounter.new(words, WORD_REGEX)
  end

  it 'should correctly initialize as a PatternCounter' do
    expect(@word_counter.class).to eq(PatternCounter)
  end

  it 'should identify the correct number of matches' do
    expect(@word_counter.matches.size).to eq(7)
  end

  it 'should identify the correct number of unique matches' do
    expect(@word_counter.unique_matches.size).to eq(4)
  end

  it 'should identify the correct unique matches' do
    expect(@word_counter.unique_matches).to eq(%w[this is and that])
  end

  it 'should correctly count and sort unique matches' do
    expect(@word_counter.unique_matches_sorted).to eq([['this', 2],
                                                    ['is', 2],
                                                    ['that', 2],
                                                    ['and', 1]])
  end
end

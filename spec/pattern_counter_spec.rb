require 'spec_helper'

describe PatternCounter do
  it 'should correctly initialize as a PatternCounter' do
    expect(PatternCounter.new('', //).class).to eq(PatternCounter)
  end
end

require 'spec_helper'

describe Hansard do
  before(:all) do
    @hansard = Hansard.new('Hansard-2015-03-25.docx')
  end

  it 'should be the correct type' do
    expect(@hansard.class).to eq(Hansard)
  end

  it 'should locate the correct number of paragraphs' do
    expect(@hansard.paragraphs.size).to eq(1238)
  end

  it 'find the first paragraph text' do
    expect(@hansard.paragraphs[0].to_s).to eq('The Council met at 9:43 a.m.')
  end
end

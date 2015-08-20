require 'spec_helper'

describe Disposition do
  before(:all) do
    @disposition = Disposition.new('Disposition-2015-03-25.docx')
  end

  it 'should be the correct type' do
    expect(@disposition.class).to eq(Disposition)
  end

  it 'should locate the correct number of tables' do
    expect(@disposition.tables.size).to eq(12)
  end
end

require 'spec_helper'

describe Disposition do
  before(:all) do
    @disposition = Disposition.new
  end
  it 'should be a sane world' do
    expect(@disposition.class).to eq(Disposition)
  end
end

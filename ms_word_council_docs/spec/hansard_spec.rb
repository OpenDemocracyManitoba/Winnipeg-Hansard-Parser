require 'spec_helper'

describe Hansard do
  before(:all) do
    @hansard = Hansard.new
  end
  it 'should be the correct type' do
    expect(@hansard.class).to eq(Hansard)
  end
end

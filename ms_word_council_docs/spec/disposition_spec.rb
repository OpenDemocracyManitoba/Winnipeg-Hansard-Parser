require 'spec_helper'

describe Disposition do
  before(:all) do
    @disposition = Disposition.new('Disposition-2015-03-25.docx')
  end

  it 'should be the correct type' do
    expect(@disposition.class).to eq(Disposition)
  end

  it 'should locate the correct number of bylaws' do
    expect(@disposition.bylaws.size).to eq(11)
  end

  it 'should correctly identify the first bylaw' do
    first_bylaw = { number:      '9/2015',
                    subject:     'To amend the Downtown Residential Development Grant Program By-law No. 77/2010.',
                    disposition: 'PASSED' }
    expect(@disposition.bylaws.first).to eq(first_bylaw)
  end

  it 'should locate the correct number of motions' do
    expect(@disposition.motions.size).to eq(8)
  end

  it 'should correctly identity the third motion' do # 3rd motion selected for it's brevity.
    third_motion = { number:      '3',
                     movers:      'Browaty / Wyatt',
                     subject:     'That the Winnipeg Public Service prepare a report on the potential vehicular implications of this development to the April 14, 2015 meeting of the Standing Policy Committee on Infrastructure Renewal and Public Works and on to Council.',
                     disposition: 'CARRIED' }
    expect(@disposition.motions[2]).to eq(third_motion)
  end
end

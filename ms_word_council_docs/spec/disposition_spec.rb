require 'spec_helper'

describe Disposition do
  before(:all) do
    @template = Disposition.new('Disposition-2015-03-25.docx')
    @actual   = Disposition.new('DISPOSITION-2015-09-03.docx')
  end

  it 'should be the correct type' do
    expect(@template.class).to eq(Disposition)
  end

  it 'should locate the correct number of bylaws passed' do
    expect(@template.bylaws.size).to eq(11)

    expect(@actual.bylaws.size).to eq(16)
  end

  it 'should correctly identify the first passed bylaw' do
    first_bylaw = { number:      '9/2015',
                    subject:     'To amend the Downtown Residential Development Grant Program By-law No. 77/2010.',
                    disposition: 'PASSED' }
    expect(@template.bylaws.first).to eq(first_bylaw)

    first_bylaw = { number:      '43/2015',
                    subject:     'To amend the North Henderson Highway Secondary Plan By-law No. 1300/1976 – SPA 1/2015',
                    disposition: 'PASSED' }
    expect(@actual.bylaws.first).to eq(first_bylaw)
  end

  it 'should locate the correct number of motions' do
    expect(@template.motions.size).to eq(8)

    expect(@actual.motions.size).to eq(13)
  end

  it 'should correctly identity the third motion' do # 3rd motion selected for it's brevity.
    third_motion = { number:      '3',
                     movers:      'Browaty / Wyatt',
                     subject:     'That the Winnipeg Public Service prepare a report on the potential vehicular implications of this development to the April 14, 2015 meeting of the Standing Policy Committee on Infrastructure Renewal and Public Works and on to Council.',
                     disposition: 'CARRIED' }
    expect(@template.motions[2]).to eq(third_motion)


    third_motion = { number:      '3',
                     movers:      'Eadie / Allard', # Fails because no spaces on actual. Split into an array instead.
                     subject:     'That the Winnipeg public service look to other Canadian cities for cannabis regulatory provisions in order to establish limits on cannabis related facilities in Winnipeg.',
                     disposition: 'AUTOMATIC REFERRAL TO THE STANDING POLICY COMMITTEE ON PROPERTY AND DEVELOPMENT' }
    expect(@actual.motions[2]).to eq(third_motion)
  end
end

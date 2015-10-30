require 'spec_helper'

describe Elected::Lider do

  let(:info) { { validity: '4948', resource: 'elected', value: 'c549b17b-3371-40c8-a8c3-221d9acf3f29' } }
  let(:timeout) { 5_000 }
  let(:exp_deadline) { Time.now + (timeout / 1000.0).to_i }

  subject { described_class.new info, timeout }

  it 'can instantiate' do
    expect(subject).to be_a described_class
  end

  it 'sets the right vars', :freeze_current_time do
    expect(subject.info).to eq info
    expect(subject.validity).to eq info[:validity]
    expect(subject.resource).to eq info[:resource]
    expect(subject.value).to eq info[:value]
    expect(subject.deadline.to_s).to eq exp_deadline.to_s
  end

  it 'gives a valid current state' do
    expect(subject.current?).to be_truthy
    Timecop.travel exp_deadline + 1
    expect(subject.current?).to be_falsey
  end

  it 'has a valid string description' do
    expect(subject.to_s).to eq '#<Elected::Lider|elected:c549b17b:4948>'
  end

end

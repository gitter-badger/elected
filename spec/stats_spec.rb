require 'spec_helper'

module Elected
  describe Stats do
    subject { described_class.new :a }
    it 'can be instantiated with no names' do
      subject = described_class.new
      expect(subject).to be_a described_class
      expect(subject.to_hash).to eq({})
      expect(subject.to_s).to eq '#<Elected::Stats >'
    end
    it 'can be instantiated with some names' do
      subject = described_class.new :a, 'b'
      expect(subject).to be_a described_class
      expect(subject.to_hash).to eq({ a: 0, b: 0 })
      expect(subject.to_s).to eq '#<Elected::Stats a=0 b=0>'
    end
    it 'can add safely in multiple threads' do
      expect(subject.count(:a)).to eq 0
      [Thread.new { 10.times.each { subject.increment :a } },
       Thread.new { 10.times.each { subject.increment :a } },
       Thread.new { 10.times.each { subject.increment :a } },
      ].map { |x| x.join }
      expect(subject.count(:a)).to eq 30
    end
  end
end
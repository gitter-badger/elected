require 'spec_helper'

module Elected
  describe Senado do

    let(:custom_key) { 'some_key' }
    let(:custom_timeout) { 5_000 }

    subject { described_class.new DEFAULT_KEY, DEFAULT_TIMEOUT }

    it 'has default key' do
      expect(subject.key).to eq DEFAULT_KEY
    end

    it 'can set key' do
      subject.key = custom_key
      expect(subject.key).to eq custom_key
    end

    it 'has default timeout' do
      expect(subject.timeout).to eq DEFAULT_TIMEOUT
    end

    it 'can set timeout' do
      subject.timeout = custom_timeout
      expect(subject.timeout).to eq custom_timeout
    end

    it 'has stats' do
      expect(subject.stats.to_s).to eq '#<Elected::Stats elected=0 missing=0 rejected=0 released=0>'
    end

    context 'elections' do

      it 'can select a leader automatically on request' do
        @key     = 'weird_key'
        @timeout = 2_000 # ms
        set_start_time

        sen1 = described_class.new @key, @timeout
        sen2 = described_class.new @key, @timeout
        sen3 = described_class.new @key, @timeout

        # First to try is leader
        expect(sen1).to be_leader
        expect(sen2).to_not be_leader
        expect(sen3).to_not be_leader

        # Still same leader
        wait_for_timeout 0.5
        expect(sen2).to_not be_leader
        expect(sen3).to_not be_leader
        expect(sen1).to be_leader

        # Time to get a new leader
        wait_for_timeout 1.1
        expect(sen3).to be_leader
        expect(sen2).to_not be_leader
        expect(sen1).to_not be_leader

        # Still same leader
        wait_for_timeout 1.6
        expect(sen2).to_not be_leader
        expect(sen1).to_not be_leader
        expect(sen3).to be_leader

        # Time to get another leader
        wait_for_timeout 2.2
        expect(sen2).to be_leader
        expect(sen3).to_not be_leader
        expect(sen1).to_not be_leader

        # Release all
        sen1.release
        sen2.release
        sen3.release

        # get stats
        expect(sen1.stats.count('elected')).to eq 1
        expect(sen2.stats.count('elected')).to eq 1
        expect(sen3.stats.count('elected')).to eq 1
      end
    end

  end
end
# frozen_string_literal: true

# require 'fast_spec_helper'

RSpec.describe Slack::Messenger::Util::UntrustedRegexp do
  def create_regex(regex_str, multiline: false)
    described_class.new(regex_str, multiline: multiline).freeze
  end

  describe '#initialize' do
    subject { described_class.new(pattern) }

    context 'invalid regexp' do
      let(:pattern) { '[' }

      it { expect { subject }.to raise_error(RegexpError) }
    end
  end

  describe '#replace_gsub' do
    let(:regex_str) { '(?P<scheme>(ftp))' }
    let(:regex) { create_regex(regex_str, multiline: true) }

    def result(regex, text)
      regex.replace_gsub(text) do |match|
        if match[:scheme]
          "http|#{match[:scheme]}|rss"
        else
          match.to_s
        end
      end
    end

    it 'replaces all instances of the match in a string' do
      text = 'Use only https instead of ftp'

      expect(result(regex, text)).to eq('Use only https instead of http|ftp|rss')
    end

    it 'replaces nothing when no match' do
      text = 'Use only https instead of gopher'

      expect(result(regex, text)).to eq(text)
    end

    it 'handles empty text' do
      text = ''

      expect(result(regex, text)).to eq('')
    end
  end

  describe '#match' do
    context 'when there are matches' do
      it 'returns a match object' do
        result = create_regex('(?P<number>\d+)').match('hello 10')

        expect(result[:number]).to eq('10')
      end
    end

    context 'when there are no matches' do
      it 'returns nil' do
        result = create_regex('(?P<number>\d+)').match('hello')

        expect(result).to be_nil
      end
    end
  end
end

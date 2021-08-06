require 'pry'
require 'spec_helper'
require_relative '../../lib/github/score'

RSpec.describe Github::Score do
  context 'when response from github successful' do 
    let!(:value) do 
      JSON.parse(File.open('spec/fixtures/files/github_response.json').read)
    end
    let!(:client) { double(Github::Client, get_events: value) }
    
    before do 
      allow(::Github::Client).to receive(:new).and_return(client)
    end

    it 'should computes a score' do
      github_score = Github::Score.new('tenderlove')
      expect(github_score.score).to eq(13)
    end
  end

  context 'when error occurs during request' do
    let!(:value) do
      OpenStruct.new(
        body: File.open('spec/fixtures/files/bad_github_response.json').read
      )
    end
    
    before do 
      allow(Net::HTTP).to receive(:get_response).and_return(value)
    end

    it 'should print error' do
      github_score = Github::Score.new('tenderlove111111111')
      expect do
        github_score.score
      end.to output('Request failed with Not Found').to_stdout
    end
  end
end


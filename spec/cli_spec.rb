require 'spec_helper'
require 'jendle'

describe Jendle::CLI do
  before do
  end

  it "should stdout sample" do
    output = capture_stdout do
      Jendle::CLI.start(['help'])
    end
    expect(output).not_to eq(nil)
  end

  it "include" do
    output = capture_stdout do
      Jendle::CLI.start(['help', 'sample'])
    end
    expect(output).to include('--fields')
  end

  after do
  end
end

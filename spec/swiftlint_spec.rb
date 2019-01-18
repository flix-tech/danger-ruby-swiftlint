# frozen_string_literal: true

require File.expand_path('../spec_helper', __FILE__)
require_relative '../ext/swiftlint/swiftlint'

describe Swiftlint do
  let(:swiftlint) { Swiftlint.new }
  let(:binary_path) { '/path/to/swiftlint' }
  it 'installed? works based on bin/swiftlint file' do
    expect(File).to receive(:exist?).with(%r{/bin\/swiftlint}).and_return(true)
    expect(swiftlint.installed?).to be_truthy

    expect(File).to receive(:exist?).with(%r{bin\/swiftlint}).and_return(false)
    expect(swiftlint.installed?).to be_falsy
  end

  context 'with binary_path' do
    let(:swiftlint) { Swiftlint.new(binary_path) }
    it 'installed? works based on specific path' do
      expect(File).to receive(:exist?).with(binary_path).and_return(true)
      expect(swiftlint.installed?).to be_truthy

      expect(File).to receive(:exist?).with(binary_path).and_return(false)
      expect(swiftlint.installed?).to be_falsy
    end
  end

  it 'runs lint by default with options being optional' do
    result = ['Report', double(success?: true)]
    expect(swiftlint).to receive(:swiftlint_path).and_return(binary_path)
    expect(Open3).to receive(:capture2).with("#{binary_path} lint ")
      .and_return(result)
    expect(swiftlint.run).to eq result
  end

  it 'runs accepting symbolized options' do
    additional_options = '--no-use-stdin  --cache-path /path --enable-all-rules'
    result = ['Report', double(success?: true)]
    expect(swiftlint).to receive(:swiftlint_path).and_return(binary_path)
    expect(Open3).to receive(:capture2).with("#{binary_path} lint #{additional_options}")
      .and_return(result)

    expect(swiftlint.run('lint',
                         '',
                         use_stdin: false,
                         cache_path: '/path',
                         enable_all_rules: true))
      .to eq result
  end
end

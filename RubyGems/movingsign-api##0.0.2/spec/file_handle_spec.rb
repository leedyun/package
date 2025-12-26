require 'spec_helper'

describe MovingsignApi::FileHandle do
  it '::handle_to_code' do
    expect(described_class.handle_to_code(0)).to eq '0'
    expect(described_class.handle_to_code(9)).to eq '9'
    expect(described_class.handle_to_code(10)).to eq 'A'
    expect(described_class.handle_to_code(35)).to eq 'Z'
  end

  it '::code_to_handle' do
    expect(described_class.code_to_handle('0')).to eq 0
    expect(described_class.code_to_handle('9')).to eq 9
    expect(described_class.code_to_handle('A')).to eq 10
    expect(described_class.code_to_handle('Z')).to eq 35
  end
end
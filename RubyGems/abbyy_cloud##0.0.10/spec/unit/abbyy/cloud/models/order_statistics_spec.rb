RSpec.describe ABBYY::Cloud::Models::OrderStatistics do
  let(:data) do
    {
      documents_count: 1,
      pages_count: 1,
      words_count: 32,
      chars_count: 103
    }
  end

  subject { described_class.new(data) }

  it { is_expected.to be_kind_of ABBYY::Cloud::Model }
  its(:to_h) { is_expected.to eq data }
end

require 'spec_helper'

describe TimeFormatValidator do
  describe '#validate_each' do
    let(:record)    { MockRecord.new }
    let(:attribute) { :time }
    let(:validator) { TimeFormatValidator.new(options) }
    before { validator.validate_each(record, attribute, value) }

    context 'for instance initialized with no options' do
      let(:options) { { attributes: attribute } }

      context 'when value is nil' do
        let(:value) { nil }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end

      context 'when value is non nil, nor Time, nor parsable to Time string' do
        let(:value) { :symbol }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end

      context 'when value is an instance of Time' do
        let(:value) { Time.now }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when value is string parsable to Time' do
        let(:value) { Time.now.to_s }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end
    end

    context 'for instance initialized with ' \
            'allow_nil as false' do
      let(:options) { { attributes: attribute, allow_nil: false } }

      context 'when value is nil' do
        let(:value) { nil }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end

      context 'when value is non nil, nor Time, nor parsable to Time string' do
        let(:value) { :symbol }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end

      context 'when value is an instance of Time' do
        let(:value) { Time.now }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when value is string parsable to Time' do
        let(:value) { Time.now.to_s }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'and after as Time' do
        let(:after) { Time.now }
        let(:options) do
          { attributes: attribute, allow_nil: false, after: after }
        end

        context 'when value is an instance of Time bellow after' do
          let(:value) { Time.now - 24 * 60 * 60 }

          it 'sets error message in record' do
            expect(record.errors[attribute].count).to eq(1)
          end
        end

        context 'when value is an instance of Time after after' do
          let(:value) { Time.now + 24 * 60 * 60 }

          it 'does not set error message in record' do
            expect(record.errors[attribute].count).to eq(0)
          end
        end
      end

      context 'and after is a Proc that returns Time' do
        let(:after) { lambda { |a| Time.now } }
        let(:options) do
          { attributes: attribute, allow_nil: false, after: after }
        end

        context 'when value is an instance of Time bellow after' do
          let(:value) { Time.now - 24 * 60 * 60 }

          it 'sets error message in record' do
            expect(record.errors[attribute].count).to eq(1)
          end
        end

        context 'when value is an instance of Time after after' do
          let(:value) { Time.now + 24 * 60 * 60 }

          it 'does not set error message in record' do
            expect(record.errors[attribute].count).to eq(0)
          end
        end
      end
    end

    context 'for instance initialized with ' \
            'allow_nil as true' do
      let(:options) { { attributes: attribute, allow_nil: true } }

      context 'when value is nil' do
        let(:value) { nil }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when value is non nil, nor Time, nor parsable to Time string' do
        let(:value) { :symbol }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end

      context 'when value is an instance of Time' do
        let(:value) { Time.now }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when value is string parsable to Time' do
        let(:value) { Time.now.to_s }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'and after as Time' do
        let(:after) { Time.now }
        let(:options) do
          { attributes: attribute, allow_nil: true, after: after }
        end

        context 'when value is an instance of Time bellow after' do
          let(:value) { Time.now - 24 * 60 * 60 }

          it 'sets error message in record' do
            expect(record.errors[attribute].count).to eq(1)
          end
        end

        context 'when value is an instance of Time after after' do
          let(:value) { Time.now + 24 * 60 * 60 }

          it 'does not set error message in record' do
            expect(record.errors[attribute].count).to eq(0)
          end
        end
      end

      context 'and after is a Proc that returns Time' do
        let(:after) { lambda { |a| Time.now } }
        let(:options) do
          { attributes: attribute, allow_nil: true, after: after }
        end

        context 'when value is an instance of Time bellow after' do
          let(:value) { Time.now - 24 * 60 * 60 }

          it 'sets error message in record' do
            expect(record.errors[attribute].count).to eq(1)
          end
        end

        context 'when value is an instance of Time after after' do
          let(:value) { Time.now + 24 * 60 * 60 }

          it 'does not set error message in record' do
            expect(record.errors[attribute].count).to eq(0)
          end
        end
      end
    end
  end
end
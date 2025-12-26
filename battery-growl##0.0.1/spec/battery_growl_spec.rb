describe BatteryGrowl do

  describe 'VERSION' do

    it 'should be 0.0.1' do
      expect( BatteryGrowl::VERSION ).to eql('0.0.1')
    end
    it 'should be a String' do
      expect( BatteryGrowl::VERSION ).to be_a(String)
    end

  end

  context 'public method' do

    describe '#run' do

      context 'When the battery level was 20% or less, ' do

        context 'growl is not running' do

          before(:each) do
            @battery_growl = BatteryGrowl.new
            @battery_growl.stub(:check_battery).and_return(10)
            @battery_growl.stub(:post_growl).with('バッテリー容量低下',"残り10%です。充電してください。",'localhost').and_raise
          end

          it 'return RuntimeError' do
            expect{ @battery_growl.run(20) }.to raise_error(RuntimeError)
          end

        end

        context 'growl is running' do

          before(:each) do
            @battery_growl = BatteryGrowl.new
            @battery_growl.stub(:check_battery).and_return(10)
            @battery_growl.stub(:post_growl).with('バッテリー容量低下',"残り10%です。充電してください。",'localhost').and_return(true)
          end

          it 'return true' do
            expect( @battery_growl.run(20) ).to be(true)
          end

        end

      end

      context 'When the battery level was more than 20%, ' do

        before(:each) do
          @battery_growl = BatteryGrowl.new
          @battery_growl.stub(:check_battery).and_return(30)
        end

        it 'return true' do
          expect( @battery_growl.run(20) ).to be(true)
        end

      end

    end

  end

  context 'private method' do

    describe '#num_check' do

      before(:each) do
        @battery_growl = BatteryGrowl.new
      end

      context 'when the number is less than 1, ' do
        it 'raise RuntimeError' do
          expect{ @battery_growl.send(:num_check, 0) }.to raise_error(RuntimeError,'Parameter is less than 1.')
        end

      end

      context 'when the number is greater than 100, ' do
        it 'raise RuntimeError' do
          expect{ @battery_growl.send(:num_check, 101) }.to raise_error(RuntimeError,'Parameter is greater than 100.')
        end
      end

      context 'when the number is between 1 and 100, ' do
        it 'return true' do
          expect( @battery_growl.send(:num_check, 1) ).to be(true)
          expect( @battery_growl.send(:num_check, 100) ).to be(true)
        end
      end

    end

    describe '#check_battery' do

      before(:each) do
        @battery_growl = BatteryGrowl.new
      end

      it 'return Integer from 1 to 100' do
        expect( @battery_growl.send(:check_battery) ).to be_within(100).of(1)
      end

    end

    describe '#post_growl' do

      context 'when growl is not running, ' do

        before(:each) do
          allow_message_expectations_on_nil
          Growl.stub(:new).with('localhost',"ruby-growl")
          @g = Growl.new('localhost','ruby-growl')
          @g.stub(:add_notification).with("notification","ruby-growl Notification")
          @g.stub(:notify).with('notification','test-subject','test-message').and_raise
          @battery_growl = BatteryGrowl.new
        end

        it 'raise RuntimeError' do
          expect{ @battery_growl.send(:post_growl, 'test-subject','test-message','localhost') }.to raise_error(RuntimeError)
        end

      end

      context 'when growl is running' do

        before(:each) do
          allow_message_expectations_on_nil
          Growl.stub(:new).with('localhost',"ruby-growl")
          @g = Growl.new('localhost','ruby-growl')
          @g.stub(:add_notification).with("notification","ruby-growl Notification")
          @g.stub(:notify).with('notification','test-subject','test-message').and_return(true)
          @battery_growl = BatteryGrowl.new
        end

        it 'return true' do
          expect( @battery_growl.send(:post_growl, 'test-subject','test-message','localhost') ).to be(true)
        end

      end

    end

  end

end

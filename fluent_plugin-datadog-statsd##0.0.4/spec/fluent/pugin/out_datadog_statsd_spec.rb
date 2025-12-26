require 'datadog/statsd'
require 'fluent/test'
require 'fluent/test/driver/output'
require 'rspec'

require 'fluent/plugin/out_datadog_statsd'

describe Fluent::Plugin::DatadogStatsdOutput do
  let(:time) do
    Time.parse('2017-06-01 00:11:22 UTC').to_i
  end

  CONFIG = %(
  ).freeze

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::DatadogStatsdOutput).configure(conf)
  end

  before do
    Fluent::Test.setup
  end

  describe '@add_fluentd_worker_id_to_tags option' do
    context 'add_fluentd_worker_id_to_tags=true' do
      it 'add worker id' do
        conf = %(
@type datadog_statsd
metric_type increment
tags ["test_tag:test"]
add_fluentd_worker_id_to_tags true
<metric>
  name test.test
</metric>
      )
        driver = create_driver(conf)

        expect(driver.instance.statsd).to receive(:increment).with('test.test', tags: ['fluentd_worker_id:0', 'test_tag:test'])

        driver.run(default_tag: 'test') do
          driver.feed(time, {})
        end
      end
    end
  end

  describe '@metric_type' do
    %i[increment decrement].each do |metric_type|
      context "metric_type=#{metric_type}" do
        it 'ok' do
          conf = %(
@type datadog_statsd
metric_type #{metric_type}
tags ["test_tag:test"]
<metric>
  name test.test
</metric>
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to receive(metric_type).with('test.test', tags: ['test_tag:test'])

          driver.run(default_tag: 'test') do
            driver.feed(time, {})
          end
        end

        it 'ok with placeholders' do
          conf = %(
@type datadog_statsd
metric_type ${metric_type}
tags ["test_tag:${tag}"]
<metric>
  name ${metric_name}
</metric>
<buffer ["tag", "metric_type", "metric_name"]>
</buffer>
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to receive(metric_type).with('test.test', tags: ['test_tag:test'])

          driver.run(default_tag: 'test') do
            driver.feed(time, 'metric_name' => 'test.test', 'metric_type' => metric_type.to_s)
          end
        end

        it 'not exist metric section' do
          conf = %(
@type datadog_statsd
metric_type #{metric_type}
tags ["test_tag:test"]
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to_not receive(metric_type)

          driver.run(default_tag: 'test') do
            driver.feed(time, {})
          end
        end
      end
    end

    %i[count gauge histgram timing set].each do |metric_type|
      context "metric_type=#{metric_type}" do
        it 'ok' do
          conf = %(
@type datadog_statsd
metric_type #{metric_type}
tags ["test_tag:test"]
<metric>
  name test.test
  value 1
</metric>
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to receive(metric_type).with('test.test', '1', tags: ['test_tag:test'])

          driver.run(default_tag: 'test') do
            driver.feed(time, {})
          end
        end

        it 'ok with placeholders' do
          conf = %(
@type datadog_statsd
metric_type ${metric_type}
tags ["test_tag:${tag}"]
<metric>
  name ${metric_name}
  value ${value}
</metric>
<buffer ["tag", "metric_type", "metric_name", "value"]>
</buffer>
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to receive(metric_type).with('test.test', '1', tags: ['test_tag:test'])

          driver.run(default_tag: 'test') do
            driver.feed(time, 'metric_name' => 'test.test', 'metric_type' => metric_type.to_s, 'value' => 1)
          end
        end

        it 'not exist metric section' do
          conf = %(
@type datadog_statsd
metric_type #{metric_type}
tags ["test_tag:test"]
      )
          driver = create_driver(conf)

          expect(driver.instance.statsd).to_not receive(metric_type)

          driver.run(default_tag: 'test') do
            driver.feed(time, {})
          end
        end
      end
    end

    context 'metric_type=event' do
      it 'ok' do
        conf = %(
@type datadog_statsd
metric_type event
tags ["test_tag:test"]
<event>
  title test_title
  text test_text
</event>
      )
        driver = create_driver(conf)

        expect(driver.instance.statsd).to receive(:event).with('test_title', 'test_text', tags: ['test_tag:test'])

        driver.run(default_tag: 'test') do
          driver.feed(time, {})
        end
      end

      it 'ok with placeholders' do
        conf = %(
@type datadog_statsd
metric_type event
tags ["test_tag:${tag}"]
<event>
  title ${title}
  text ${text}
  aggregation_key ${aggregation_key}
  alert_type ${alert_type}
  date_happened ${date_happened}
  priority ${priority}
  source_type_name ${source_type_name}
</event>
<buffer ["title", "text", "tag", "aggregation_key", "alert_type", "date_happened", "priority", "source_type_name"]>
</buffer>
      )
        driver = create_driver(conf)

        expect(driver.instance.statsd).to receive(:event).with(
          'test_title', 'test_text', tags: ['test_tag:test'], aggregation_key: 'ak', alert_type: 'info', date_happened: time, priority: 'low', source_type_name: 'stn'
        )

        driver.run(default_tag: 'test') do
          driver.feed(time, 'title' => 'test_title', 'text' => 'test_text', 'aggregation_key' => 'ak',
                            'alert_type' => 'info', 'date_happened' => time, 'priority' => 'low', 'source_type_name' => 'stn')
        end
      end

      it 'not exist event section' do
        conf = %(
@type datadog_statsd
metric_type event
tags ["test_tag:test"]
      )
        driver = create_driver(conf)

        expect(driver.instance.statsd).to_not receive(:event)

        driver.run(default_tag: 'test') do
          driver.feed(time, {})
        end
      end
    end
  end
end

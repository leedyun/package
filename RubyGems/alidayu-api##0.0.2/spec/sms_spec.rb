require 'spec_helper'

describe "test sms api" do
  it "should send message success" do
    options = { mobiles: '13681695220', template_code: 'SMS_5410467', params: { code: '1234567', product: '就诊通' } }

    data = Alidayu::Sms.send(options)

    expect(data["alibaba_aliqin_fc_sms_num_send_response"]["result"]["success"]).to eq(true)
  end

  it "should send message fail" do
    options = { mobiles: '13681695220', template_code: 'SMS_5410467', params: { code: '123567' } }

    data = Alidayu::Sms.send(options)

    expect(data["error_response"]).to be_an_instance_of(Hash)
  end

  it "should query message record" do
    options = { mobile: '13681695220', query_date: '20160401', current_page: 1, page_size: 10 }

    data = Alidayu::Sms.query(options)

    expect(data["alibaba_aliqin_fc_sms_num_query_response"]).to be_an_instance_of(Hash)
  end

  it "should send message success by invalid json param" do
    options = {
      mobiles: "13681695220",
      template_code: "SMS_7245708",
      params: {
        order_id: 12345678,
        register_mobile: 13681695220,
        patient_name: "张三",
        contact_mobile: 13681695220
      }
    }

    data = Alidayu::Sms.send(options)
    expect(data["alibaba_aliqin_fc_sms_num_send_response"]["result"]["success"]).to eq(true)
  end

 end
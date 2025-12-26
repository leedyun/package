require 'spec_helper'

describe "test tts api" do
  it "should send tts success" do
    options = { called_num: '13681695220', called_show_num: '10086', template_code: 'TTS_5410474', params: { product: '就诊通', code: '1234567' } }
    
    data = Alidayu::Tts.single_call(options)

    expect(data["alibaba_aliqin_fc_sms_num_send_response"]["result"]["success"]).to eq(true)
  end

  it "should send tts fail" do
    options = { called_num: '13681695220', called_show_num: '10086', template_code: 'TTS_5410474', params: { product: '就诊通' } }

    data = Alidayu::Tts.single_call(options)

    expect(data["error_response"]).to be_an_instance_of(Hash)
  end

 end
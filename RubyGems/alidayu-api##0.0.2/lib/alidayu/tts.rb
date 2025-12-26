module Alidayu
  module Tts
    class << self
      include Alidayu::Helper

      # 文本转语音通知
      # { called_num: '', called_show_num: '', template_code: '', params: {  } }
      def single_call(params)
        params[:method] = 'alibaba.aliqin.fc.tts.num.singlecall'
        params[:tts_code] = params.delete(:template_code)
        if params[:params].is_a? Hash
          tts_param = params[:params].to_json
          params.delete(:params)
          params[:tts_param] = tts_param
        end
        response = get_response(params)
      end
    end
  end
end
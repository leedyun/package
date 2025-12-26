module Alidayu
  module Voice
    class << self
      include Alidayu::Helper

      METHOD_HASH = {
        voice_double_call: "alibaba.aliqin.fc.voice.num.doublecall",
        voice_single_call: "alibaba.aliqin.fc.voice.num.singlecall"
      }

      # 语音双呼
      # { caller_num: '', caller_show_num: '', called_num: '', called_show_num: '' }
      def double_call(params)
        params[:method] = METHOD_HASH[:voice_double_call]
        params[:session_time_out] = params.delete(:time_out)

        response = get_response(params)
      end

      # 语音通知
      #  { called_num: '', called_show_num: '', voice_code: '' }
      def single_call(params)
        params[:method] = METHOD_HASH[:voice_single_call]

        response = get_response(params)
      end

    end
  end
end
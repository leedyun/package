# encoding: utf-8

module ApnsPolite

	require 'json'

	class Message

		# 初期化
		def initialize(device_token, message)

			t = package_device_token device_token

			if message.is_a? Hash
				m = package_message message[:alert], message[:badge], message[:sound], message[:other]
			else
				m = package_message message.to_s
			end

			@pack = [0, 0, 32, t, 0, m.bytesize, m].pack("ccca*cca*")
		end
		# パックしたメッセージ取得
		def pack
			@pack
		end

	private
		# device token パッケージ化
		def package_device_token(device_token)
			[device_token.gsub(/[\s|<|>]/,'')].pack('H*')			
		end
		# message パッケージ化
		def package_message(alert, badge=nil, sound=nil, options=nil)
			a = { 'aps' => {} }
			a['aps']['alert'] = alert if alert
			a['aps']['badge'] = badge if badge
			a['aps']['sound'] = sound if sound
			a.merge! options if options
			a.to_json
		end
	end

end # end of module


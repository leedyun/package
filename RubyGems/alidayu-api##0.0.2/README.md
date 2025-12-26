# AlidayuApi

alidayu api for ruby

阿里大鱼相关API调用，可调用

1. 短信发送 `alibaba.aliqin.fc.sms.num.send`  
2. 短信发送记录查询 `alibaba.aliqin.fc.sms.num.query`
3. 文本转语音通知 `alibaba.aliqin.fc.tts.num.singlecall`
4. 语音通知 `alibaba.aliqin.fc.voice.num.singlecall`
5. 语音双呼 `alibaba.aliqin.fc.voice.num.doublecall`

## 安装

添加下面的代码到Gemfile中:

```ruby
gem 'alidayu_api', '~> 0.0.1', require: "alidayu"
```

然后执行:

    $ bundle install

或者执行下面的代码:

    $ gem install alidayu_api

## 使用
### 配置
创建脚本`config/initializers/alidayu.rb`填入以下代码

```ruby
Alidayu.setup do |config|
  config.server     = 'http://gw.api.taobao.com/router/rest'
  config.app_key    = ''
  config.app_secret = ''
  config.sign_name  = '注册验证'
end
```

短信发送模板请自行根据需求定义
	
### 短信发送

```ruby
options = {
  mobiles: '13681695220',
  template_code: 'SMS_5410467',
  params: {
   code: '45678',
   product: '就诊通'
  }
}
# params为模板内容的变量集合，根据模板中定义变量的不同而不同，若模板中未定义变量可不传

Alidayu::Sms.send(options)
```

### 短信发送记录查询

```ruby
options = {
  mobile: '13681695220',
  query_date: 'yyyyMMdd',
  current_page: 1, # 页码
  page_size: 10 # 每页数量，最大50
}

Alidayu::Sms.query(options)

```

### 文本转语音通知

```ruby
options = {
  called_num: '',
  called_show_num: '',
  template_code: '', # 文本转语音（TTS）模板ID
  params: {  } # TTS模板变量，同短信发送的params
}

Alidayu::Tts.single_call(options)
```

### 语音通知

```ruby
options = {
  called_num: '',
  called_show_num: '',
  voice_code: '' # 语音文件ID
}

Alidayu::Voice.single_call(options)
```

### 语音双呼

```ruby
options = {
  caller_num: '',
  caller_show_num: '',
  called_num: '',
  called_show_num: '',
  time_out: '' # 通话超时时长，如接通后到达120秒时，通话会因为超时自动挂断。若无需设置超时时长，可不传
}

Alidayu::Voice.double_call(options)
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/alidayu_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

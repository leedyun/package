require "spider_html/version"
# require "#{Dir.pwd}/initializers/constants.rb"
require "net/http"
require "openssl"
require "yaml"

class SpiderHtml
  # SpiderHtml.request_http("https://www.baidu.com")
  # SpiderHtml.request_http("https://www.baidu.com",{method: post})
  # opt传入method,默认是get方法
  # return {body: body, code: code}
  def self.request_http(url, opt={})
    uri = URI(url)
    if opt[:method] == "post"
      req = Net::HTTP::Post.new(uri)
    else
      req = Net::HTTP::Get.new(uri)
    end
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https', :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) {|http|
      http.request(req)
    }
    return {body: res.body, code: res.code}
  end

  # SpiderHtml.phantom_file("https://www.baidu.com", "baidu.html")
  # SpiderHtml.phantom_file("https://www.baidu.com", "baidu.html", image_dir: "#{Dir.pwd}/image", html_dir: "#{Dir.pwd}/html")
  # 可以默认在项目里面constants/spider_html.yml
  # 可以传入image_dir,html_dir,logger
  def self.phantom_file(url, file_name, opt={})
    spider_html_path = "#{Dir.pwd}/config/constants/spider_html.yml"
    if File.exist?(spider_html_path)
      spider = YAML.load_file(spider_html_path)
    else
      spider = YAML.load_file(File.join(File.dirname(__FILE__), "spider_html.yml"))
    end
    image_dir = opt[:image_dir].nil?? spider["image_dir"] : opt[:image_dir]
    html_dir = opt[:html_dir].nil?? spider["html_dir"] : opt[:html_dir]
    js_path = File.join(File.dirname(__FILE__), "phantom.js")
    logger = opt[:logger]

    if file_name.include?(".png")
      path = "#{image_dir}/#{file_name}"
    else
      path = "#{html_dir}/#{file_name}"
    end

    dir_path = File.dirname(path)
    FileUtils.mkdir_p(dir_path)

    order = "phantomjs #{js_path} #{url} #{path}"
    self.log_info(logger, "system:#{order}")
    result = system order
    if !result
      self.log_error(logger, "phantomjs error:#{order}")
    end
  end

  private
  def self.log_info(logger, msg)
    if logger
      logger.info msg
    else
      p msg
    end
  end

  def self.log_error(logger, msg)
    if logger
      logger.error msg
    else
      p msg
    end
  end
end

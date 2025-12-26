require 'mechanize'

module RoyalMailScraper
  class Tracker::Request < Struct.new(:tracking_number)
    REQUEST_URI = URI('http://www.royalmail.com/trackdetails')
    TIMEOUT = 10
    RETRIES_ON_ERROR = 7

    def execute
      Tracker::Response.new(fetch_details_page.body)
    end

    private

    def fetch_details_page
      form = with_retry(RETRIES_ON_ERROR, Error) { fetch_form }

      form.tracking_number = tracking_number

      result = with_retry(RETRIES_ON_ERROR, Error) { submit_form(form) }

      result
    end

    def submit_form(form)
      result = form.submit
      find_form(result)
      result
    end

    def fetch_form
      find_form(agent.get(REQUEST_URI))
    end

    def find_form(page)
      page.form_with(id: 'bt-tracked-track-trace-form') ||
        raise(Error, 'Tracking code form not found')
    end

    def agent
      @agent ||= build_agent
    end

    def build_agent
      agent = Mechanize.new
      agent.open_timeout = TIMEOUT
      agent.read_timeout = TIMEOUT
      agent.user_agent_alias = 'Windows Chrome'
      agent
    end

    def with_retry(retries, exception_class, interval = 0.5)
      attempt = 0

      begin
        attempt += 1
        yield
      rescue *exception_class => e
        if attempt == retries
          raise e
        else
          sleep interval
          retry
        end
      end
    end
  end
end

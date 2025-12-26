
module Cnvrg
    class Auth
        #include Thor::Actions

        def is_logged_in?
            n = Netrc.read
            return false if n[Cnvrg::Helpers.netrc_domain].nil?

            email, token = n[Cnvrg::Helpers.netrc_domain]
            not (email.empty? or token.empty?)
        end

        def get_email
            n = Netrc.read
            email, token = n[Cnvrg::Helpers.netrc_domain]

            if self.is_logged_in?
                return email
            else
                return nil
            end
        end

        def get_token
            n = Netrc.read
            email, token = n[Cnvrg::Helpers.netrc_domain]

            if self.is_logged_in?
                return token
            else
                return nil
            end
        end

        def ask(message)
            HighLine.new.ask(message)
        end


        def ask_password(message)
            HighLine.new.ask(message) do |q|
                q.echo = false
            end
        end

        def sign_in(email, password, token: nil)
            url = Cnvrg::API.endpoint_uri()
            url = URI.parse(url+ "/users/sign_in")
            http = Net::HTTP.new(url.host, url.port)

            if url.scheme == 'https'
                http.use_ssl = true
                if !Helpers.is_verify_ssl
                    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                end


            end
            req = Net::HTTP::Post.new(url.request_uri)

            req.add_field("EMAIL", email)
            req.add_field("PASSWORD", password)
            if token.present?
                req.add_field("Authorization", "CAPI #{token}")
            end

            response = http.request(req)

            result = JSON.parse(response.body)
            if Cnvrg::CLI.is_response_success(result)
                return result["result"]
            end


        end




    end
end

module Any
  module Validate
    module Mailaddress

      def valid_mailaddress? mail: nil
        # http://tmtms.hatenablog.com/entry/2014/09/09/mailaddress-regexp
        return true if mail =~ 
          /\A
            # 全体で256文字以下
            (?=.{,256}\z)
            # local-partは64文字以下でdomainは255文字以下
            (?=.{,64}@.{,255}\z)
            # local-part
            (
              # dot-atom
              (?<atom>[0-9a-z!\#$%&'*+\-\/=?^_`{|}~]+)
              (\.\g<atom>)*
            |
              # quoted-string
              \"([\x09\x20\x21\x23-\x5b\x5d-\x7e]|\\[\x09\x20-\x7e])*\"
            )@
            # domain
            (?<sub_domain>[0-9a-z]([0-9a-z-]{,61}[0-9a-z])?)
            (\.\g<sub_domain>)*
          \z/ix
        return false
      rescue
        return false
      end

    end
  end
end

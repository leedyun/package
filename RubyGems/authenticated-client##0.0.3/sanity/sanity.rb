require 'authenticated_client'
require 'yaml'

class Main

  def generate_keypair
    #create and configure auditing instance
    keypair_generator = AuthenticatedClient::KeypairGenerator.new
    private_key, public_key = keypair_generator.generate
    configuration = {
      'private_key' => private_key,
      'public_key' => public_key
    }
    print configuration.to_yaml
  end

  def round_trip_simple_code
    $stderr.puts "Generating Keypair..."
    $ecdsa_key = OpenSSL::PKey::EC.new 'secp521r1'
    $ecdsa_key.generate_key
    $ecdsa_public = OpenSSL::PKey::EC.new $ecdsa_key
    $ecdsa_public.private_key = nil
    $stderr.puts "Generation Complete"

    $stderr.puts 'DIRECT'
    json_stuff = { 'stuff' => 'bla' }
    token = encode(json_stuff)
    result = decode(token)
    $stderr.puts result

    extracted_private_key = $ecdsa_key.to_pem
    extracted_public_key = $ecdsa_public.to_pem
    $ecdsa_key = nil
    $ecdsa_public = nil

    $stderr.puts 'INDIRECT'
    $ecdsa_key = OpenSSL::PKey::EC.new extracted_private_key
    $ecdsa_public = OpenSSL::PKey::EC.new ''#extracted_public_key
    token = encode(json_stuff)
    result = decode(token)
    $stderr.puts result
  end

  def encode(payload)
    JWT.encode(payload, $ecdsa_key, 'ES512')
  end

  def decode(authentication_token)
    JWT.decode(authentication_token, $ecdsa_public, true, { :algorithm => 'ES512' })
  end
end

main = Main.new
main.generate_keypair
main.round_trip_simple_code

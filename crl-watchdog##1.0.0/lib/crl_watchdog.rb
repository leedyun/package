require 'openssl'

class CrlWatchdog

  VERSION = '1.0.0'

  attr_reader :crl

  def initialize crl_file
    ensure_file_exists! crl_file
    @crl = OpenSSL::X509::CRL.new File.read(crl_file)
  end

  def next_update
    crl.next_update
  end

  def expires_within_days? days
    days = days.to_i
    ensure_positive_day_count! days
    next_update >= (Time.now + 86000 * days)
  end

  private

  def ensure_file_exists! file
    raise ArgumentError.new("File not found: #{file}") unless File.exists?(file)
  end

  def ensure_positive_day_count! days
    raise ArgumentError.new('Must pass positive integer for days count') if days <= 0
  end

end

class LdapApi

  YOOX = {
    name: 'YOOX',
    host: 'ydcrootblq.yoox.net',
    base: 'dc=yoox,dc=net',
    port: 389,
    user: ENV['YOOX_BIND_USER'],
    pass: ENV['YOOX_BIND_PASS'],
  }
  NAP = {
    name: 'LONDON',
    host: 'RODC02-PR-IMO.london.net-a-porter.com',
    base: 'dc=london,dc=net-a-porter,dc=com',
    port: 389,
    user: ENV['NAP_BIND_USER'],
    pass: ENV['NAP_BIND_PASS'],
  }

  DOMAINS = [ YOOX, NAP ]

  def domains
    domain_structs = DOMAINS.map do |domain|
      d = OpenStruct.new(
        name: domain[:name],
        user: domain[:user],
        pass: domain[:pass],
        ldap: Net::LDAP.new(
          host: domain[:host],
          port: domain[:port],
          base: domain[:base],
          auth: {
            method: :simple,
            username: domain[:user],
            password: domain[:pass],
          },
        )
      )
      raise "BIND ERROR: #{domain}" unless d.ldap.bind
      d
    end
  end

  def auth?(username, password)
    domains.each do |domain|
      domain.ldap.authenticate domain.name + "\\" + username, password
      return true if domain.ldap.bind
    end
    return false
  end

  def groups(name)
    filter = Net::LDAP::Filter.eq("sAMAccountName", name)
    results = []
    domains.map do |domain|
      domain.ldap.search(filter: filter) do |entry|
        results << entry.memberof.map {|e| e.sub(/^CN=/,'').sub(/,.*$/,'') }
      end
      domain.ldap.get_operation_result
    end
    results.flatten
  end

  def user(name)
    filter = Net::LDAP::Filter.eq("sAMAccountName", name)
    results = []
    domains.map do |domain|
      domain.ldap.search(filter: filter) do |entry|
        results << entry
      end
      domain.ldap.get_operation_result
    end
    results.flatten
  end

  def group(name)
    filter = Net::LDAP::Filter.eq("cn", name)
    results = []
    domains.map do |domain|
      domain.ldap.search(filter: filter) do |entry|
        results << entry
      end
      domain.ldap.get_operation_result
    end
    results.flatten
  end

  def in_group?(name, group)
    groups(name).include?(group)
  end

  def users_in_group(group)
    filter = Net::LDAP::Filter.eq("cn", group)
    results = []
    domains.map do |domain|
      domain.ldap.search(filter: filter) do |entry|
        results << entry.member.map {|e| user_from_name(e.sub(/^CN=/,'').sub(/,.*$/,'')) }
      end
      domain.ldap.get_operation_result
    end
    results.flatten
  end

  def user_from_name(name)
    filter = Net::LDAP::Filter.eq("cn", name)
    results = []
    domains.map do |domain|
      domain.ldap.search(filter: filter) do |entry|
        results << entry[:samaccountname]
      end
      domain.ldap.get_operation_result
    end
    results.flatten
  end
end

# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize

class LicenseUsageSeed
  def self.seed!
    admin_user = User.find_by(username: 'root')
    group_count = seed_groups.count
    user_count = seed_users.count

    puts 'Start seeding license usage data...'

    rand(5..20).times { create_group(admin_user) }
    create_users_and_members

    puts 'Creating License usage record...'
    create_license_usage_record

    puts "Created #{seed_users.count - user_count} users and #{seed_groups.count - group_count} groups."
    puts 'License usage data seeding completed.'
  end

  def self.create_user
    name = "test-user#{SecureRandom.hex(8)}"

    User.create!(
      email: "#{name}@test.com",
      password: SecureRandom.hex.slice(0, 16),
      username: name,
      name: "User #{name}",
      confirmed_at: Time.current
    )
  end

  def self.create_group(user)
    name = "test-group#{SecureRandom.hex(8)}"
    group_params =
      {
        name: name,
        path: name
      }
    ::Groups::CreateService.new(user, group_params).execute
  end

  def self.create_users_and_members
    seed_groups.pluck(:id).each do |group_id|
      3.times { create_member(create_user, group_id) }
    end
  end

  def self.create_member(user, group_id)
    # Excludes GUEST role based on ultimate license seat count
    roles = [Gitlab::Access::REPORTER, Gitlab::Access::DEVELOPER, Gitlab::Access::MAINTAINER]

    GroupMember.create(user_id: user.id, access_level: roles.sample, source_id: group_id)
    Users::UpdateHighestMemberRoleService.new(user).execute
  end

  def self.seed_users
    User.where('username ~* ?', '^test-user')
  end

  def self.seed_groups
    Group.where('name ~* ?', '^test-group')
  end

  def self.create_license_usage_record
    # Force update daily billable users and historical license data
    identifier = Analytics::UsageTrends::Measurement.identifiers[:billable_users]
    ::Analytics::UsageTrends::CounterJobWorker.new.perform(identifier, User.minimum(:id), User.maximum(:id),
      Time.zone.now)

    HistoricalData.track!
  end
end

LicenseUsageSeed.seed!

# rubocop:enable Metrics/AbcSize

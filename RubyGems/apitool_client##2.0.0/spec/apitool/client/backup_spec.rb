require 'spec_helper'

describe Apitool::Client::Backup, order: :defined do
  before(:context) do
    @client = Apitool::Client::Backup.new({
      host: "127.0.0.1",
      port: 3001,
      ssl: false,
      token: API_KEY,
      version: "v2"
    })
  end

  #it "should be possible to crud backups" do
  #  expect(@client.index.class).to be Array
  #  uuid = SecureRandom.uuid
  #  backup = "david"
  #  path = [uuid, backup].join('/')
#
  #  backup = @client.create(path)
  #  expect(@client.result).to be 200
  #  expect(backup[:backup][:path]).to eq path
#
  #  loaded_backup = @client.show(path)
  #  expect(@client.result).to be 200
  #  expect(loaded_backup[:backup][:path]).to eq path
#
  #  @client.destroy(path)
  #  expect(@client.result).to be 200
  #end

end

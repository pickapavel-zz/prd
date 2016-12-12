class AddFakeUsers < ActiveRecord::Migration[5.0]
  def self.up
    User.create(name: "Jan Skoupý", password: 'enrian', email: "Jan.skoupy@tatrabanka.sk", team: "quality", role: 1)
    User.create(name: "Richa Bhardwaj", password: 'enrian', email: "richa.bhardwaj@tatrabanka.sk", team: "quality", role: 0)
  end

  def self.down
  end
end

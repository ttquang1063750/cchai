begin
  shards = {:my_shards => {}}
  DbConnect.all.each do |shard|
    shards[:my_shards][shard.database] = {:host => shard.host, :adapter => shard.adapter, :database => shard.database, :username => shard.username, :password => shard.password, :port => shard.port}
  end

  Octopus.setup do |config|
    config.environments = [:production, :development]
    config.shards = shards
  end
rescue ActiveRecord::StatementInvalid => e
  puts e
end

module Shard_Connect
  def self.connect_to_shard
    shards = {:my_shards => {}, :shards => {}}
    DbConnect.all.each { |shard|shards[:my_shards][shard.database] = {:host => shard.host, :adapter => shard.adapter, :database => shard.database, :username => shard.username, :password => shard.password, :port => shard.port} }
    Octopus.setup do |config|
      config.environments = [:production, :development]
      config.config.merge!(replicated: true, fully_replicated: true) #replication when using dynamic configuration
      config.shards = shards
    end
  end
end


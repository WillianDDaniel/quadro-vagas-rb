$redis = Redis.new(url: ENV["REDIS_URL"] || "redis://redis:6379/0")

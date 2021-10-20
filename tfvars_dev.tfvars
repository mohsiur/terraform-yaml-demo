example-queue-dlq = "example-queue-dlq"
example-queue     = "example-queue"

example-queues = ["example-queue-dlq", "example-queue"]
alternative_maps = [
  {
    "name" : "example-queue-dlq",
    "visibility_timeout_seconds" : 10
    "type" : "standard",
    "access_policy" : "basic"
  },
  {
    "name" : "example-queue"
    "visibility_timeout_seconds" : 10,
    "type" : "standard",
    "access_policy" : "basic"
  }
]

# As you can see we need to start writing complex tfvars, which becomes 
# more nested as we introduce features
# testing local features

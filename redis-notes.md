# Redis Notes

## Get a list of keys

You can list all keys in Redis:

```bash
redis> keys *
```

Or you can use the glob pattern:

```bash
redis> keys sidekiq*
# 1) "sidekiq:stat:processed:2016-04-26"
# 2) "sidekiq:processes"
# 3) "sidekiq:queues"
# 4) "sidekiq:ip-172-31-13-9:12066:de4c0df743d1:workers"
# 5) "sidekiq:stat:processed"
# 6) "sidekiq:ip-172-31-13-9:12066:de4c0df743d1"
# 7) "sidekiq:stat:processed:2016-04-27"
```

This will match all keys that start with "sidekiq".

## Finding the type of a key

To get the contents of a key, you first need to find out its type:

```bash
redis> type sidekiq:ip-172-31-13-9:12066:de4c0df743d1:workers
# hash
```

## Get the contents of a hash

For example, say we want to look at our current Sidekiq workers:

```bash
redis> hgetall sidekiq:ip-172-31-13-9:12066:de4c0df743d1:workers
# 1) "szlis"
# 2) "{\"queue\":\"default\",\"payload\":{\"class\":\"ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper\",\"wrapped\":\"CreateForecastJobForTrancheVersion\",\"queue\":\"default\",\"args\":[{\"job_class\":\"CreateForecastJobForTrancheVersion\",\"job_id\":\"70c29af0-196a-4902-b035-02808291ac38\",\"queue_name\":\"default\",\"arguments\":[8],\"locale\":\"en\"}],\"retry\":true,\"jid\":\"304a418b3cb89bdcef7e7ace\",\"created_at\":1461714639.5868776,\"enqueued_at\":1461714639.5869234},\"run_at\":1461714641}"
```

This gives you a listing of keys and values.  

You can get a list of just values with:

```bash
redis> hvalues sidekiq:ip-172-31-13-9:12066:de4c0df743d1:workers
```
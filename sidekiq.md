# Sidekiq Notes

#### restarting when server restarts

It is highly recommended that you use runit or upstart to bring the service back up on a server restart:

https://github.com/mperham/sidekiq/blob/master/examples/upstart/manage-one/sidekiq.conf

#### Number of sidekiq processes running

This defaults to 1 per app server.  The Capistrano add-ons do this by default.
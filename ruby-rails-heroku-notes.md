# Heroku Rails Notes

Heroku CLI commands documentation: https://devcenter.heroku.com/articles/heroku-cli-commands

## Install the command line app

```bash
$ brew tap heroku/brew && brew install heroku
```

## Login on the command line

```bash
$ heroku login
```

## Create an app

```bash
$ heroku apps:create example
```

## Deploy a simple Sinatra app

```bash
$ mkdir my-foo-foo && cd my-foo-foo
$ git init
$ bundle init
$ bundle inject sinatra "~> 2.0.0"
$ bundle
```

Add the `config.ru` file:

```ruby
require "rubygems"
require "bundler/setup"
require "sinatra"

get "/" do
  "Hello, from my foo foo"
end

run Sinatra::Application
```

Run the app locally:

```bash
$ bundle exec rackup
# => http://localhost:9292
```

Make sure to gitignore gem files if you are configured to store them in `vendor/bundle`.

Deploy to heroku:

```bash
$ git add .
$ git commit -m "Init commit"
$ heroku git:remote -a my-foo-foo

# deploy the app
$ git push heroku master

# open the app and view the hello message
$ heroku open
```

## Run the rails console

```bash
$ heroku run rails c -a APP_NAME
```

## Ensure you have a dyno running

If you have more than 1 web dyno running, this will scale down to 1.  However, with a new environment this will ensure you have at least one.

```bash
$ heroku ps:scale web=1
```

## Upgrade to the hobby plan

By default, new applications are deployed to a free dyno. Free apps will “sleep” to conserve resources.

```bash
$ heroku ps:resize hobby
```

## Setting up a quick Rails site

Create the app with the Postgres database

```bash
$ rails new my-foo-foo --database=postgresql
$ cd my-foo-foo

$ r g controller Hello world
```

Add this content to `app/views/hello/world.html.erb`:

```html
<h2>Hello World</h2>
```

Setup the database and run the server to verify it works:

```ruby
$ rails db:create db:migrate
$ rails server
```

Check `http://localhost:3000` and ensure the "Hello, World" message shows up.

Add your app to git:

```bash
$ git init
$ git add .
$ git commit -m "Init commit"
```

Create the app on heroku, push to it, and verify the deploy worked:

```bash
$ heroku apps:create my-foo-foo
$ git push heroku master
$ heroku open
```

## Setting up Puma

https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

Add a `Procfile` file to the root directory of the app:

```Procfile
web: bundle exec puma -C config/puma.rb
```

## Setting up Sidekiq

https://github.com/mperham/sidekiq/wiki/Deployment#heroku

Add the Sidekiq gem to the `Gemfile`:

```ruby
gem "sidekiq"
```

You need to set Rails's ActiveJob to use Sidekiq `config/application.rb`:

```ruby
class Application < Rails::Application
  # ...
  config.active_job.queue_adapter = :sidekiq
end
```

```Procfile
worker: bundle exec sidekiq -t 25 -q default -q mailers
```

Add Redis support:

```bash
$ heroku addons:create heroku-redis
```

After deploying, add a dyno for the worker:

```bash
$ heroku ps:scale worker=1
```

## Running migrations on deploy

https://devcenter.heroku.com/articles/release-phase

```Procfile
release: bundle exec rake db:migrate
```

## Setting up a custom domain

This was a little more painful than expected.  Heroku won't give you an IP address, so you can't create a traditional A record for your bare domain.

You can use CloudFlare to manage your DNS, and Cloudflare allows you to add in a CNAME for a root domain that it "flattens".

### View domains

```bash
$ heroku domains
```

### Add domain

```bash
$ heroku domains:add bmarks.xyz
```

## View information about certificates

```bash
$ heroku certs
```

## View configuration

```bash
$ heroku config
```

## Set a config variable

```bash
$ heroku config:set FOO="bar"
```

## Add the current directory to app

If you haven't connected to an app yet, you need to issue all of your heroku commands with an `--app` flag.

To connect to the app:

```bash
$ heroku git:remote -a <app name>
```

## Set a daily database backup

You can check your current backup schedules with

```bash
$ heroku pg:backups:schedules -a elliot-app
# ▸    No backup schedules found on ⬢ elliot-app
# ▸    Use heroku pg:backups:schedule to set one up
```

You can create a schedule like this:

```bash
$ heroku pg:backups:schedule DATABASE_URL --at '02:00 America/Los_Angeles' -a elliot-app

$ heroku pg:backups:schedules -a elliot-app
# === Backup Schedules
# DATABASE_URL: daily at 2:00 America/Los_Angeles
```

## Upgrading the database plan from hobby to next level

https://devcenter.heroku.com/articles/updating-heroku-postgres-databases

The only option for upgrading a hobby database is with `pg:copy`.  There is another way to upgrade a production database you are already paying for that will likely result in less downtime, if it's important.  The difference my only be seconds to a few minutes.

To use the `pg:copy` approach, you need to provision a new database and copy the data into it.

```bash
$ heroku addons:create heroku-postgresql:hobby-basic
```

You can view both databases:

```bash
$ heroku addons
```

This will show you the environment variable to use to copy:

```bash
$ heroku pg:copy DATABASE_URL HEROKU_POSTGRESQL_PINK
```

Then you need to promote the new database:

```bash
$ heroku pg:promote HEROKU_POSTGRESQL_PINK
```

## Upgrading database version

TODO

https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases

## SSH into container

```bash
$ heroku ps:exec -a <app-name>
```

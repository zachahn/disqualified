# Disqualified

I wanted a small background job framework that used SQLite as the backend.

Since SQLite doesn't have any features like Postgres' `LISTEN`/`NOTIFY`,
Disqualified resorts to polling the database. This might _disqualify_ it as an
option for you, but it works well enough for my workload.

Note that:

* Disqualified only works with Rails.
* Disqualified does not support multiple queues.
* Disqualified supports Postgres and MySQL, but it isn't particularly optimized
  for them.
* Each Disqualified process assumes it's the only process running. Running
  multiple instances of Disqualified should not hurt, but it is not supported.


## Usage

Run `bundle exec disqualified --help` for more information on how to run the
Disqualified server. This is what I use in production:

```
env RAILS_ENV=production bundle exec disqualified
```

You can use Disqualified with ActiveJob, or you can use it by itself.
The examples below detail how to use it by by itself. See Installation
instructions for information on how to set up integration with ActiveJob.


### Defining a job

```ruby
class ComplicatedJob
  include Disqualified::Job

  def perform(arg1, arg2)
    # ...
  end
end
```


### Queuing

```ruby
ComplicatedJob.perform_async(1, 2)
ComplicatedJob.perform_in(1.minute, 1, 2)
ComplicatedJob.perform_at(3.days.from_now, 1, 2)
```


## Installation

Run this in your shell, in your Rails app.

```bash
bundle add disqualified
bundle exec rails generate disqualified:install
bundle binstub disqualified
```

Please remember to run `rails generate disqualified:install` when upgrading
Disqualified! It is mostly an idempotent command and will prepare any necessary
database migrations.


### ActiveJob

You can optionally set up Disqualified as ActiveJob's default backend.

Usually, you'll just need to update your `config/environments/production.rb`
file to include something like this.

```ruby
require "disqualified/active_job"

Rails.application.configure do
  # ...
  config.active_job.queue_adapter = :disqualified
  # ...
end
```


## Contributing

PRs are welcome! Please confirm the change with me before you start working;
some features might be better off as a plugin or as a fork.

When submitting a PR, and if you prefer, please `Allow edits from maintainers`.
This will help get your contributions merged in a bit faster.


## License

The gem is available as open source under the terms of the
[LGPL v3 License](https://opensource.org/licenses/LGPL-3.0).

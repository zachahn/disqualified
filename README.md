# Disqualified

I wanted a small background job framework that used SQLite as the backend.

Since SQLite doesn't have any features like Postgres' `LISTEN`/`NOTIFY`,
Disqualified resorts to polling the database. This might _disqualify_ it as an
option for you, but it works well enough for my workload.

Disqualified only works with Rails. You can use it with ActiveJob or by itself.


## Usage

Run `bundle exec disqualified --help`


## Installation

Run this in your shell, in your Rails app.

```bash
bundle add disqualified
bundle exec rails generate disqualified:install
bundle binstub disqualified
```


## Contributing

PRs are welcome! Please confirm the change with me before you start working;
some features might be better off as a plugin or as a fork.

When submitting a PR, and if you prefer, please `Allow edits from maintainers`.
This will help get your contributions merged in a bit faster.


## License

The gem is available as open source under the terms of the
[LGPL v3 License](https://opensource.org/licenses/LGPL-3.0).

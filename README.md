# LEARN Notes Application

### Getting Started

1. You must have the following dependencies installed:

   - Ruby 3
     - See [`.ruby-version`](.ruby-version) for the specific version used in this application.
     - Use [rvm](https://rvm.io/) to install local Ruby versions.
   - Node
     - See [`.nvmrc`](.nvmrc) for the specific version used in this application.
     - Use [nvm](https://formulae.brew.sh/formula/nvm) to install local Node versions.
   - [PostgreSQL 14](https://formulae.brew.sh/formula/postgresql@14)
   - [Redis 6.2](https://formulae.brew.sh/formula/redis)
   - [Chrome](https://www.google.com/search?q=chrome) for headless browser tests.

2. Run the `bin/setup` script.

   - Look for failures. Solve only one issue at a time.
   - Use [Homebrew Formulae](https://formulae.brew.sh/) to install any necessary technologies.

3. Start the application with `bin/dev`.

   - Run the redis server with `redis-server`.

4. Visit http://localhost:3000.

### Linting Commands

- `bundle exec standardrb` will run the standardrb linter and highlight issues
- `standardrb --fix` automatic linting for quick formatting fixes

### Test Suite

- `rails test` to run the Minitest in the command line

### Information about Bullet Train

If this is your first time working on a Bullet Train application, be sure to review the [Bullet Train Basic Techniques](https://bullettrain.co/docs/getting-started) and the [Bullet Train Developer Documentation](https://bullettrain.co/docs).

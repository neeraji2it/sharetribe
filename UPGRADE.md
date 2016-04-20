# Upgrade

Upgrade notes will be documented in this file.

## General update instructions

First things first, take a backup of your database before updating.

When updating, always run the following commands to update gem set, database structure and recompile custom stylesheet:

```bash
bundle install
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake sharetribe:generate_customization_stylesheets_immediately

# if running on local instance (localhost), you need to precompile assets using once update is done:
rake assets:precompile
```

## Unreleased

This release adds a new Delayed Job queue "css_compile". All CSS compilations during the deployment are added to this queue. However, CSS compilations triggered from the admin UI do NOT go into this queue, instead they are added to the "default" queue.

A new worker is added to the Procfile to work for the new queue. If you're hosting in Heroku, you will see a new worker there.

This change doesn't require any changes if you are compiling the stylesheets synchronously using the `rake sharetribe:generate_customization_stylesheets_immediately` command during the deployment. However, if you are compiling the stylesheets asynchronously using the `rake sharetribe:generate_customization_stylesheets` command, then you need to make sure that you have at least one worker working for the "css_compile" queue.

## Upgrade from 5.5.0 to 5.6.0

Ruby version is updated from 2.1.8 to 2.2.4. The update should reduce memory usage and improve performance.

Using [RVM](https://rvm.io/), you can upgrade your local Ruby version like this:

```
rvm install ruby-2.2.4
rvm use ruby-2.2.4
gem install bundler
bundle install
```

## Upgrade from 5.4.0 to 5.5.0

This release removes the support for legacy hashing algorithm that was used with the legacy "ASI" service.

If `use_asi_encryptor` was configured to `false` (default) then you can safely upgrade and roll back this release.

However, if `use_asi_encryptor` was configured to `true` then you can not roll back this released without losing user authentication data. If you need to roll back, users need to request new password by clicking the "Forgot password link".

## Upgrade from 5.3.0 to 5.4.0

Ruby version is updated from 2.1.2 to 2.1.8. The update contains security and bug fixes.

Using [RVM](https://rvm.io/), you can upgrade your local Ruby version like this:
```
rvm install ruby-2.1.8
rvm use ruby-2.1.8
gem install bundler
bundle install
```

## Upgrade from 5.2.x to 5.3.0

This version contains some changes to the caching logic. The Rails cache needs to be cleared before upgrading.

Upgrade path:

1. Upgrade to version 5.2.2
2. Clear Rails cache (run `Rails.cache.clear`)
3. Upgrade to version 5.3.0

## Upgrade from 5.0.x or 5.1.x to 5.2.0

* After updating, you are not able to downgrade to Rails 3 (version 4.6.0). Do not upgrade until you are sure that you don't need to roll back to Rails 3.

* You need to set `secret_key_base` to environment variables or to `config.yml` for `production` environment. Default values for `development` and `test` environments are provided.

  Run `SecureRandom.hex(64)` in rails console or irb to generate a new key.

* This version changes the way how password reset tokens are being stored to the database. Due to this, tokens that are created with the earlier versions do not work anymore.

  For seamless migration, set the environment variable `devise_allow_insecure_token_lookup` to `true`. After you are sure you have migrated all the reset tokens to the new format, you can remove the environment variable.

## Upgrade from 4.6.0 to 5.0.0

After you have deployed the new version you need to clear Rails cache by running to following command in your production application Rails console:

```
Rails.cache.clear
```

If something goes wrong, you can safely roll back this version back to 4.6.0. You don't need to roll back the database migrations. You may need to empty the cache again after the rollback.

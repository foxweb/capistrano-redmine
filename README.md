# capistrano-redmine

This gem contains a Capistrano :task, which allows to update the Redmine issues
statuses when you do deploy with Capistrano. For example, to change issues
status from "Waiting for deploy" to "Waiting for review."

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-redmine', :require => false

or

    gem 'capistrano-redmine', :git => 'git://github.com/foxweb/capistrano-redmine.git', :require => false

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install capistrano-redmine

## Usage

1. Install and config you [Capistrano](https://github.com/capistrano/capistrano/) utility.
2. Install _capistrano-redmine_.
3. Change directory to RAILS_ROOT of your app.
3. Add this variables in `config/deploy.rb`:

    ```ruby
      # settings for capistrano-redmine
      set :redmine_site, "http://localhost:3000" # Redmine app host and port
      set :redmine_token, "376ba30fca80867d10a0ec0b505e5c97834901e3" # Redmine API key
      set :redmine_options, {}
      set :redmine_projects, "test-project" # you project identifier or array of.
      set :redmine_from_status, 1 # Redmine status ID "from"
      set :redmine_to_status, 3 # Redmine status ID "to"
      require "capistrano-redmine"
    ```

    and

    ```ruby
      after "deploy", "redmine:update"
    ```

    Specify the necessary settings for your Redmine.

    If you want to use specific options of ActiveResource (some HTTP of SSL options), you can add the following settings. Specify `:ssl` options if you use HTTPS connection to Redmine. Specify `:proxy` URL if you use HTTP-proxy.

    ```ruby
      set :redmine_options, {
        :ssl => {
                :cert => OpenSSL::X509::Certificate.new(File.read("cert.pem")),
                :key  => OpenSSL::PKey::RSA.new(File.read("key.pem"))
              },
        :proxy => 'http://user:password@proxy.people.com:8080'
      }
    ```

4. Check installation with command

    `bundle exec cap -T redmine`

    You should see line:

    `cap redmine:update        # Update Redmine issues statuses.`

5. Start `bundle exec cap deploy` or `bundle exec cap redmine:update`.
6. Check your Redmine issues and enjoy it!

## Redmine API config

1. To enable the API-style authentication, you have to check Enable REST API in **Administration → Settings → Authentication**.
2. Create new user named like 'deploy' (or other) and login with this.
3. You can find your API key on your account page ( /my/account ) when logged in, on the right-hand pane of the default layout.
4. Copy and paste API key to the `config/deploy.rb` on `set :redmine_token`.

## Documentation

* [Capistrano Wiki](http://github.com/capistrano/capistrano/wiki/)
* [Redmine API](http://www.redmine.org/projects/redmine/wiki/Rest_api)

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Added some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create new Pull Request.

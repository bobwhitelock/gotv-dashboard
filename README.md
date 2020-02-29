
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

# GOTV Dashboard

## Guides

### Setup for local development

1. Install the Ruby version specified in [`.ruby-version`](./.ruby-version) by
   some method for your operating system - if you do not have an existing
   preferred method for doing this:
   - on Linux/macOS you can use [`rbenv`](https://github.com/rbenv/rbenv) with
     [`ruby-build`](https://github.com/rbenv/ruby-build);
   - on Windows you can use
     [RubyInstaller](https://rubyinstaller.org/downloads/).

2. Install [Mozilla Geckodriver](https://github.com/mozilla/geckodriver) via
   some means (e.g. Brew or any Linux package manager), in order to run feature
   tests which use Selenium.

3. Clone and set up the repo:

   ```bash
   git clone git@github.com:CampaignLab/gotv-dashboard.git
   cd gotv-dashboard
   gem install bundler
   gem update --system
   bundle install --without production
   rake db:setup
   rails server
   ```

4. To create a work space for development, either:

   a. visit `http://localhost:3000` and click the link to generate a demo work
   space;

   b. or, if you have access to Contact Creator and some real data, and want to
   try using this, export this data and run:

   ```bash
   rake gotv:import_contact_creator \
      name=$name_for_your_work_space \
      polling_stations=$url_for_polling_stations_data \
      campaign_stats=$url_for_campaign_stats_data
   ```

### To run tests

The dashboard has fairly complete test coverage, and this should ideally be
maintained as new features are added. Most of the test coverage is via
[Capybara](https://github.com/teamcapybara/capybara) feature tests, and so will
require Mozilla Geckodriver to run as described
[above](#setup-for-local-development).

To run tests, use `rspec`.

Once all tests have been run, `coverage/index.html` can be viewed in a browser to see all test coverage.

### To access admin dashboard

1. Have `GOTV_DASHBOARD_PASSWORD` environment variable exported in your
   environment before running the app, e.g. like this:
     ```bash
     export GOTV_DASHBOARD_PASSWORD='verysecure123'
     bin/rails server
     ```

2. Visit `$dashboard_url/admin` - where `$dashboard_url` is the URL you are
   accessing the GOTV dashboard at, e.g. `http://localhost:3000` by default.

3. Enter username as `admin`, password as the value exported above.

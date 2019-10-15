
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

2. Clone and set up the repo:

   ```bash
   git clone git@github.com:CampaignLab/gotv-dashboard.git
   cd gotv-dashboard
   gem install bundler
   bundle install gotv-dashboard
   rake db:setup
   rails server
   ```

3. Possibly other steps - to be continued...

4. To import/generate useful data for development:

   ```bash
   rake gotv:import_councils
   rake gotv:import_redbridge
   rake gotv:randomize_figures
   ```

### To access admin dashboard

1. Have `GOTV_DASHBOARD_PASSWORD` environment variable exported in your
   environment before running the app, e.g. like this:
     ```bash
     export GOTV_DASHBOARD_PASSWORD='verysecure123'
     bin/rails server
     ```

2. Visit `${dashboard_url}/admin`

3. Enter username as `admin`, password as the value exported above.

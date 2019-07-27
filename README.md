
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](code-of-conduct.md)

# GOTV Dashboard

## Guides

### To access admin dashboard

1. Have `GOTV_DASHBOARD_PASSWORD` environment variable exported in your
   environment before running the app, e.g. like this:
     ```bash
     export GOTV_DASHBOARD_PASSWORD='verysecure123'
     bin/rails server
     ```

2. Visit `${dashboard_url}/admin`

3. Enter username as `admin`, password as the value exported above.

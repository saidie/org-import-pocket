# org-import-pocket

## Installation

1. Create new Pocket App on [https://getpocket.com/developer/](https://getpocket.com/developer/) with `Modify` and `Retrieve` permissions
2. Put your App's consumer key to `.consumer_key` file in the repository top
3. `bundle install`

## Authorization

A script asks you opening an authorization URL at first time. Copy & paste the URL to browser and authorize your App.

## Scripts

### `bin/todolize_archived_items.rb`

This script prints your archived items as org-mode format.

### `bin/remove_archived_items.rb`

This script removes your archived items.

#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Bundler.require
require 'pocket_api'

items = get_items(state: :archive)['list']
exit 0 if items.empty?

item_ids = items.values.map { |item| item['item_id'].to_i }
remove_items(item_ids)

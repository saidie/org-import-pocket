#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Bundler.require
require 'pocket_api'

items = get_items(state: :archive)['list']
exit 0 if items.empty?

puts '* TOREAD'
items.values.each do |item|
  added = Time.at(item['time_added'].to_i)
  title = item['resolved_title'] || item['given_title']
  url = item['resolved_url'] || item['given_url']

  puts <<ARTICLE
** #{title}
[#{added.strftime('%Y-%m-%d %a %H:%M')}]

#{url}

#{item['excerpt']}

ARTICLE
end

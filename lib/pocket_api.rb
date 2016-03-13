require 'json'

ACCESS_TOKEN_PATH = File.join(File.dirname(__FILE__), '..', '.access_token')
CONSUMER_KEY_PATH = File.join(File.dirname(__FILE__), '..', '.consumer_key')

def http_get(url)
  `curl '#{url}'`
end

def http_post(url, params)
  `curl -XPOST '#{url}' #{params.map { |k, v| "-F '#{k}=#{v}'" }.join(' ')}`
end

def pocket_api_url(path, params={})
  uri = Addressable::URI.parse(File.join('https://getpocket.com', path))
  uri.query_values = (uri.query_values || {}).merge(params)

  uri.to_s
end

def consumer_key
  @consumer_key ||= File.read(CONSUMER_KEY_PATH).strip
end

def authorize
  content = http_post(
    pocket_api_url('/v3/oauth/request'),
    consumer_key: consumer_key,
    redirect_uri: 'http://localhost'
  )
  code = content.split('=')[1]

  puts 'Open following link in your browser, authorize this app and enter `yes` to proceed'
  puts pocket_api_url(
    '/auth/authorize',
    request_token: code,
    redirect_uri: 'http://localhost'
  )

  exit 1 if STDIN.gets.strip.casecmp('yes') != 0

  content = http_post(
    pocket_api_url('/v3/oauth/authorize'),
    consumer_key: consumer_key,
    code: code
  )
  Hash[content.split('&').map { |l| l.split('=') }]
end

def access_token
  @access_token ||=
    begin
      return File.read(ACCESS_TOKEN_PATH).strip if File.exist?(ACCESS_TOKEN_PATH)

      access_token = authorize['access_token']

      open(ACCESS_TOKEN_PATH, 'w') { |fout| fout.puts access_token }

      access_token
    end
end

def get_items(params = {})
  url = pocket_api_url(
    '/v3/get',
    {
      consumer_key: consumer_key,
      access_token: access_token,
    }.merge(params)
  )
  content = http_get(url)
  JSON.parse(content)
end

def remove_items(item_ids)
  url = pocket_api_url(
    '/v3/send',
    consumer_key: consumer_key,
    access_token: access_token,
    actions: item_ids.map do |item_id|
      {
        action: :delete,
        item_id: item_id,
      }
    end.to_json
  )
  http_get(url)
end

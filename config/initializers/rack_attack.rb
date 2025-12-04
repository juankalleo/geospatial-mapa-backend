class Rack::Attack
  # Throttle route calculation requests
  throttle('route_calculation/ip', limit: 30, period: 1.minute) do |req|
    if req.path == '/api/route' && req.post?
      req.ip
    end
  end

  # Throttle general API requests
  throttle('api/ip', limit: 300, period: 5.minutes) do |req|
    req.ip if req.path.start_with?('/api')
  end

  # Block requests from known bad actors
  blocklist('block_bad_actors') do |req|
    # Add IPs or patterns to block
    # Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 10.minutes, bantime: 1.hour) do
    #   req.path.include?('wp-admin') || req.path.include?('phpmyadmin')
    # end
  end
end

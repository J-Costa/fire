Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: "./db/geo_ip/GeoLite2-City.mmdb"
  }
)

#!/usr/bin/env ruby
require 'rest-client'
require 'yaml'
require 'nokogiri'
require "awesome_print"
require 'uri'

def parse_address
  @parse_address ||= YAML.load_file('address.yaml')
end

def site
  @site ||= 'http://mcriblocator.com/resources.php'
end

def fetch_data
  street = parse_address[:street]
  city = parse_address[:city]
  state = parse_address[:state]
  country = parse_address[:country]
  RestClient.get(site, {
    params: {
      latlon: 1,
      street: street,
      city: city,
      state: state,
      country: country
    }
  }).body
end

def fetch_locations(http)
  latitude, longitude = http.split(">")[-1].strip.split(';')
  RestClient.get(site, {
    params: {
      nearestMcRib: 1,
      latitude: latitude,
      longitude: longitude
    }
  }).body
end

def parse_output(output)
  doc = Nokogiri::HTML(output)
  headers = ["Distance (Miles)","Street","City","State","Confirmed"]
  # get table rows
  rows = []
  doc.xpath('//*/tr').each_with_index do |row, i|
    rows[i] = {}
    row.xpath('td').each_with_index {|td, j| rows[i][headers[j]] = td.text}
  end

  rows.each {|row| ap row}
end

results = fetch_locations(fetch_data)
parse_output(results)

#!/usr/bin/env ruby
require 'httparty'
require 'world_airports'
require 'table_print'

r = HTTParty.get(
    'http://map.aviasales.ru/prices.json',
    query: {
        origin_iata: 'MOW',
        period: '2020-03-01:month',
        direct: true,
        one_way: false,
        locale: 'ru',
        min_trip_duration_in_days: 2,
        max_trip_duration_in_days: 2
    }
)

puts r.size

r.select! { |v| v['depart_date'] == '2020-03-07' }.sort_by! { |v| v['value'] }.map! do |v|
  {
      value: v['value'].to_i,
      city: WorldAirports.iata(v['destination'])&.city || v['destination'],
      country: WorldAirports.iata(v['destination'])&.country || v['destination'],
      iata: v['destination']
  }
end

TablePrint::Config.max_width = 80
tp r
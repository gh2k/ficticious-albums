#!/usr/bin/env ruby

require_relative 'lib/randomtext.rb'

# Thanks to:
# https://github.com/KevinBongart/ourbandiscalled
# https://github.com/tjarratt/RandomTextGen

ITEM_COUNT = 1000

manifest = {}

ITEM_COUNT.times do
  album = RandomText::Album.new

  manifest[album.slug] = album.rating
  File.write("output/#{album.slug}.json", album.to_json)
end

File.write('output/manifest.json', manifest.sort_by { |slug, rating| rating }.reverse.map { |s| s[0] }.to_json)


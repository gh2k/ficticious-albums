# Thanks, https://github.com/KevinBongart/ourbandiscalled/blob/master/app/models/record.rb

require File.expand_path 'text_generator', File.dirname(__FILE__)

require 'open-uri'
require 'nokogiri'
require 'json'
require 'titleize'
require 'parameterize'

I18n.enforce_available_locales = false

module RandomText
end

class RandomText::Album

  GENRES = %w(
    World
    Soundtrack
    Folk
    Singer/Songwriter
    Rock
    Reggae
    Soul
    Funk
    Pop
    Latin
    K-Pop
    J-Pop
    Jazz
    Electronic
    Industrial
    Indie
    Alternative
    Hip-Hop
    Country
    Blues
  )

  attr_accessor :band, :wikipedia_url, :title, :quotationspage_url, :cover, :flickr_url, :slug, :description, :genre, :rating

  def initialize
    set_band_name
    set_album_name
    set_album_cover
    set_slug
    set_description
  end

  def to_json
    j = {}
    instance_variables.each do |v|
      j[v.to_s.sub /^@/, ''] = instance_variable_get v
    end

    j.to_json
  end

  private

  def set_band_name
    url = "https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=1&rnnamespace=0&format=json"
    json = JSON.parse open(url).read
    title = json["query"]["random"].first["title"]
    band_name = title.gsub(/ \(.*\)$/, '')
    band_name = band_name.titleize
    @band = band_name
    @wikipedia_url = "http://en.wikipedia.org/wiki/#{title.gsub(/ /, '_')}"
  end

  def set_album_name
    url = "http://www.quotationspage.com/random.php3"
    body = Nokogiri::HTML(open(url))
    last_quote = body.search("dt[@class*=quote]").last.search("a").first
    quote = last_quote.inner_html
    last_words = quote.split(/ /)
    last_words = last_words.last(4)
    last_words.last.gsub!(/\./, '')
    album_name = last_words.join(" ")
    album_name = album_name.titleize
    @title = album_name
    @quotationspage_url = "http://www.quotationspage.com/#{last_quote.attributes['href'].value}"
  end

  def set_album_cover
    url = "https://www.flickr.com/explore/interesting/7days/"
    body = Nokogiri::HTML(open(url))
    third_photo = body.css("span.photo_container.pc_m")[2].at("a")
    album_cover = third_photo.at("img")
    album_cover = album_cover.attributes["src"].value
    @cover = album_cover
    @flickr_url = "http://www.flickr.com#{third_photo.attributes['href'].value}"
  end

  def set_slug
    @slug = "#{@title.parameterize}-by-#{@band.parameterize}"
  end

  def set_description
    gen = RandomText::TextGenerator.new

    gen.seed(File.read(File.expand_path 'roy.txt', File.dirname(__FILE__)))

    lines = []

    (2..5).to_a.sample.times do
      lines << gen.generate
    end

    @description = lines.join('\n')
    @genre = GENRES.sample
    @rating = (rand(-10).round / 2.0).to_s
  end

end
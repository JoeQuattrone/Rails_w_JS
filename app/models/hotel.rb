require 'nokogiri'
require 'open-uri'
require 'rest-client'
require 'net/http'
require 'json'



class Hotel < ApplicationRecord
  has_many :users, through: :visits
  has_many :visits

  validates :name, uniqueness: true, presence: true
  validates :address, presence: true
  validates :image_url, presence: true
  validates :price, presence: true
  validates :city, presence: true

  def self.query_by_city(city)
    where(city: city)
  end

  def self.query_by_price(max_price)
    where(price: (0)..max_price.to_i)
  end

  def self.get_data(city)
    doc = Nokogiri::HTML(open("https://www.hotels.com/search.do?q-destination=#{city}"))

    doc.css(".hotel-wrap").first(15).each do |hotel|
      hotel_name =  hotel.css(".p-name").css("a").text.strip

      img_url = hotel.css(".u-photo").first.values.last.split(/'/)[1] rescue img_url ="https://via.placeholder.com/250x140"


      hotel_price =  hotel.css(".price").css("ins").text.gsub(/\D/, '')

      if hotel_price.empty?
        hotel_price =  hotel.css(".price").text.gsub(/\D/, '')
      end

      hotel_address =  hotel.css(".contact").text

      Hotel.create(name: hotel_name, image_url: img_url, price: hotel_price, address: hotel_address, city: city)
    end
  end

  def self.get_data2(city)
    uri = URI('https://api.proxycrawl.com')
    uri.query = URI.encode_www_form({
    token: 'ySdaNYV4217OA4IhAPXhVQ',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.1 Safari/605.1.15',

    url: "https://www.hotels.com/search.do?q-destination=#{city}
  "})

    res = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML(res.body)
    body = doc.css("body")
    body.css(".main-inner").css(".hotel-wrap").first(15).each do |hotel|
      hotel_name =  hotel.css(".p-name").css("a").text.strip

      img_url = hotel.css(".u-photo").first.values.last.split(/'/)[1] rescue img_url ="https://via.placeholder.com/250x140"


      hotel_price =  hotel.css(".price").css("ins").text.gsub(/\D/, '')
        #convert RUB to USD
      if hotel_price.empty?
        if hotel.css(".price").text.match?(/RUB/)
            hotel_price = (hotel.css(".price").text.gsub(/\D/, '').to_f * (0.015)).to_s
        else
            hotel_price =  hotel.css(".price").text.gsub(/\D/, '')
        end
      end
      hotel_address =  hotel.css(".contact").text

      Hotel.create(name: hotel_name, image_url: img_url, price: hotel_price, address: hotel_address, city: city)
    end
  end


end

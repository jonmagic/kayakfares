require 'uri'
require 'mechanize'

# KayakFares takes a hash of parameters, from/to/depart/return and then uses
# the Kayak search API (http://www.kayak.com/s/search/air) and Mechanize
# to scrape the results and give you an easy to use array of hashes with
# the flight prices and details.
class KayakFares

  # Creates a new instance of KayakFares.
  #
  # params - Hash with from/to/depart/return, accepts airport code for
  #          from/to and YYYY/MM/DD or MM/DD/YYYY for depart/return
  #
  # Returns instance of KayakFares
  def initialize(params)
    @params = params
    @mechanize = Mechanize.new {|a| a.user_agent_alias = 'Mac Safari' }
    @base_url = "http://www.kayak.com"
  end

  # Takes parameters and compiles them into a URL encoded string.
  #
  # Returns a string
  def compiled_params
    params_array = []
    params_array << "l1=#{escape(@params[:from])}"   if @params[:from]
    params_array << "l2=#{escape(@params[:to])}"     if @params[:to]
    params_array << "d1=#{escape(@params[:depart])}" if @params[:depart]
    params_array << "d2=#{escape(@params[:return])}" if @params[:return]
    params_array.join('&')
  end

  # Takes the compiled params and Kayak search url and mashes them together.
  #
  # Returns a string
  def url
    "#{@base_url}/s/search/air?#{compiled_params}"
  end

  # Loads search results page using Mechanize.
  #
  # Returns an instance of Mechanize::Page
  def load_page
    @page ||= @mechanize.get(url)
  end

  # Extracts the search result nodes from the search results page.
  #
  # Returns an instance of Nokogiri::XML::NodeSet which behaves like an Array
  def extract_rows
    @rows ||= load_page.search("//div[contains(concat(' ',normalize-space(@class),' '),' flightresult ')]")
  end

  # URL encodes string.
  #
  # value - any string
  #
  # Returns a string
  def escape(value)
    URI.escape(value, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  # Compiles and returns an array of hashes with flight details.
  #
  # Returns an Array
  def results
    extract_rows.map do |result|
      hash = {}
      hash[:price] = result.xpath(".//a[contains(concat(' ',normalize-space(@class),' '),' results_price ')]").text.strip
      hash[:airline] = result.xpath(".//div[contains(concat(' ',normalize-space(@class),' '),' rsAirlineName ')]").text.strip
      legs = result.xpath(".//div[@class='singleleg']")
      hash[:leg0_departure_time] = legs[0].xpath(".//div[@class='flighttime']")[0].text.strip
      hash[:leg0_arrival_time] = legs[0].xpath(".//div[@class='flighttime']")[1].text.strip
      hash[:leg0_duration] = legs[0].xpath(".//div[@class='duration']")[0].text.strip
      hash[:leg1_departure_time] = legs[1].xpath(".//div[@class='flighttime']")[0].text.strip
      hash[:leg1_arrival_time] = legs[1].xpath(".//div[@class='flighttime']")[1].text.strip
      hash[:leg1_duration] = legs[1].xpath(".//div[@class='duration']")[0].text.strip
      hash[:booking_url] = @base_url + result.xpath(".//a[@class='dealsinresult']")[0].attributes['rel'].value
      hash
    end
  end
end
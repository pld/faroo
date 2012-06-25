require 'rubygems'

require 'cgi'
require 'json'
require 'open-uri'


FarooResult = Struct.new :title, :abstract, :url, :image_url, :domain, :author,
    :news, :votes, :date, :related


class Faroo 
  # API for Faroo search engine
  # 
  # Example:
  #   >> Faroo.new('[Referer]', ['Num results']).search('nano fibers')
  #   => [ #<ClioResult:...>, ... ]
  #
  # Arguments:
  #   referer: (String)
  #   num_results: (Integer+)

  API_PATH = 'http://www.faroo.com/instant.json?'

  attr_accessor :referer, :num_results

  def initialize(referer='', num_results=100)
    @referer = referer
    @num_results = num_results
  end

  def web(query, start=1, language='en')
    search(query, 'web', start, language)
  end

  def news(query, start=1, language='en')
    search(query, 'news', start, language)
  end
  
  def search(query, src, start, language)
    # API Parameters
    # q=query
    # start=start
    # length=length
    # l=language (en, de, zh)
    # src=source (web, news)

    params = "start=#{start}&length=#{@num_results}&q=#{CGI.escape(query)}"
    params += "&src=#{src}&l=#{language}"
    response = open(API_PATH + params, { 'Referer' => @referer })
    return nil if response.class.superclass == Net::HTTPServerError
    doc = JSON.load(response)

    return [] if doc['length'] == 0

    doc['results'].map do |result|
      FarooResult.new(
        result['title'],
        result['kwic'],
        result['url'],
        result['iurl'],
        result['domain'],
        result['author'],
        result['news'],
        result['votes'],
        result['date'],
        result['related']
      )
    end
  end
end

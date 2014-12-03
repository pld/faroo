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

  API_PATH = 'http://www.faroo.com/api?'
  CHUNK_SIZE = 10
  MAX_TTL = 2

  attr_accessor :referer, :num_results

  def initialize(api_key, opts = {})
    @api_key = api_key
    @referer = opts[:referer] || ""
    @num_results = opts[:num_results] || 100
    @chunk_size = 10
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

    params = "length=#{CHUNK_SIZE}&q=#{CGI.escape(query)}&src=#{src}&l=#{language}&key=#{@api_key}"

    result = nil

    url = "#{API_PATH}#{params}"
    response = open(url, { 'Referer' => @referer })
    unless response.class.superclass == Net::HTTPServerError
       doc = JSON.load(response)
       results = doc['results']
       puts result
       results.map do |result|
         FarooResult.new(
           result['title'],
            result['kwic'],
            result['url'],
            result['iurl'],
            result['domain'],
            result['author'],
            result['news'],
            result['votes'],
            Time.at(result['date'] / 1000),
            result['related']
         )
       end
    end
  end
end

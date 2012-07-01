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
  CHUNK_SIZE = 10
  MAX_TTL = 2

  attr_accessor :referer, :num_results

  def initialize(referer='', num_results=100)
    @referer = referer
    @num_results = num_results
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

    # faster with 10
    params = "length=#{CHUNK_SIZE}&q=#{CGI.escape(query)}&src=#{src}&l=#{language}"
    results = []
    threads = []

    # Faroo API significantly faster when results are of size 10
    1.upto(@num_results / 10) do |start|
      threads << Thread.new(start) do |_start|
        url = "#{API_PATH}#{params}&start=#{(_start - 1) * CHUNK_SIZE + 1}"
        response = open(url, { 'Referer' => @referer })
        unless response.class.superclass == Net::HTTPServerError
          doc = JSON.load(response)
          results += doc['results']
        end
      end
    end

    threads.each { |thread| thread.join(MAX_TTL) }

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
#        result['date'],
        Time.now,
        result['related']
      )
    end
  end
end

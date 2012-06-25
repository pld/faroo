require 'benchmark'
require 'test/unit'

require 'faroo'


class FarooTest < Test::Unit::TestCase

  def setup
    @obj = Faroo.new('example.com')
  end

  def test_set_referer
    e = Faroo.new('ref')
    assert_equal 'ref', e.referer
  end

  # requires internet connectivity
  def test_get_search_response
    assert_equal false, @obj.web('nano fibers').empty?
  end

  # requires internet connectivity
  def test_get_num_search_response
    @obj.num_results = 10
    assert_equal 10, @obj.web('nano fibers').length
  end

  # requires internet connectivity
  def test_work_with_fewer_than_limit_returned
    # if 'helicoid' returns >= 100 results this test is trivial
    assert_equal false, @obj.web('helicoid').empty?
  end

  def test_set_start
    assert_equal false, @obj.web('helicoid', 10).empty?
  end

  def test_set_language_de
    assert_equal false, @obj.web('zukunft', 1, 'de').empty?
  end


  def test_set_language_zh
    assert_equal false, @obj.web('iphone', 1, 'zh').empty?
  end

  # requires internet connectivity
  def test_get_news_search_response
    assert_equal false, @obj.news('nano fibers').empty?
  end

  # requires internet connectivity
  def test_return_empty_if_not_results
    # if 'Ambiogenesis568' returns results this test is trivial
    assert_equal true, @obj.web('Ambiogenesis568').empty?
  end

  # benchmark
  def test_benchmark_no_asserts
    Benchmark.bm(10) do |x|
      (10..100).step(10) do |max|
        @obj.num_results = max
        x.report("web search #{max}:") { results = @obj.web('helioid') }
      end
    end
  end
end


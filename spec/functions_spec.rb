gem 'minitest'
require 'minitest/autorun'
require 'ruby2js/filter/functions'

describe Ruby2JS::Filter::Functions do
  
  def to_js( string)
    Ruby2JS.convert(string, filters: [Ruby2JS::Filter::Functions])
  end
  
  describe 'conversions' do
    it "should handle to_s" do
      to_js( 'a.to_s' ).must_equal 'a.toString()'
    end

    it "should handle to_s(16)" do
      to_js( 'a.to_s(16)' ).must_equal 'a.toString(16)'
    end

    it "should handle to_a" do
      to_js( 'a.to_a' ).must_equal 'a.toArray()'
    end

    it "should handle to_i" do
      to_js( 'a.to_i' ).must_equal 'parseInt(a)'
    end

    it "should handle to_i(16)" do
      to_js( 'a.to_i' ).must_equal 'parseInt(a)'
    end

    it "should handle to_f" do
      to_js( 'a.to_f' ).must_equal 'parseFloat(a)'
    end

    it "should handle puts" do
      to_js( 'puts "hi"' ).must_equal 'console.log("hi")'
    end
  end

  describe 'string functions' do
    it 'should handle sub' do
      to_js( 'str.sub("a", "b")' ).must_equal 'str.replace("a", "b")'
      to_js( 'str.sub(/a/) {"x"}' ).
        must_equal 'str.replace(/a/, function() {return "x"})'
      to_js( 'str.sub!("a", "b")' ).
        must_equal 'var str = str.replace("a", "b")'
      to_js( 'item.str.sub!("a", "b")' ).
        must_equal 'item.str = item.str.replace("a", "b")'
      to_js( '@str.sub!("a", "b")' ).
        must_equal 'this._str = this._str.replace("a", "b")'
      to_js( '@@str.sub!("a", "b")' ).
        must_equal 'this.constructor._str = this.constructor._str.replace("a", "b")'
      to_js( '$str.sub!("a", "b")' ).
        must_equal 'var $str = $str.replace("a", "b")'
      to_js( 'str.sub!(/a/) {"x"}' ).
        must_equal 'var str = str.replace(/a/, function() {return "x"})'
    end

    it 'should handle gsub and gsub!' do
      to_js( 'str.gsub("a", "b")' ).must_equal 'str.replace(/a/g, "b")'
      to_js( 'str.gsub(/a/i, "b")' ).must_equal 'str.replace(/a/gi, "b")'
      to_js( 'str.gsub(/a/, "b")' ).must_equal 'str.replace(/a/g, "b")'
      to_js( 'str.gsub(/a/) {"x"}' ).
        must_equal 'str.replace(/a/g, function() {return "x"})'
      to_js( 'str.gsub!("a", "b")' ).
        must_equal 'var str = str.replace(/a/g, "b")'
      to_js( 'item.str.gsub!("a", "b")' ).
        must_equal 'item.str = item.str.replace(/a/g, "b")'
      to_js( 'str.gsub!(/a/, "b")' ).
        must_equal 'var str = str.replace(/a/g, "b")'
    end

    it 'should handle ord and chr' do
      to_js( '"A".ord' ).must_equal '65'
      to_js( 'a.ord' ).must_equal 'a.charCodeAt(0)'
      to_js( '65.chr' ).must_equal '"A"'
      to_js( 'a.chr' ).must_equal 'String.fromCharCode(a)'
    end

    it "should handle downcase" do
      to_js( 'x.downcase()' ).must_equal 'x.toLowerCase()'
    end

    it "should handle upcase" do
      to_js( 'x.upcase()' ).must_equal 'x.toUpperCase()'
    end

    it 'should handle start_with?' do
      to_js( 'x.start_with?(y)' ).must_equal 'x.substring(0, y.length) == y'
      to_js( 'x.start_with?("z")' ).must_equal 'x.substring(0, 1) == "z"'
    end

    it 'should handle end_with?' do
      to_js( 'x.end_with?(y)' ).must_equal 'x.slice(-y.length) == y'
      to_js( 'x.end_with?("z")' ).must_equal 'x.slice(-1) == "z"'
    end
  end
    
  describe 'array functions' do
    it "should map each to forEach" do
      to_js( 'a = 0; [1,2,3].each {|i| a += i}').
        must_equal 'var a = 0; [1, 2, 3].forEach(function(i) {a += i})'
    end

    it "should map each_with_index to forEach" do
      to_js( 'a = 0; [1,2,3].each_with_index {|n, i| a += n}').
        must_equal 'var a = 0; [1, 2, 3].forEach(function(n, i) {a += n})'
    end

    it "should handle first" do
      to_js( 'a.first' ).must_equal 'a[0]'
      to_js( 'a.first(n)' ).must_equal 'a.slice(0, n)'
    end

    it "should handle last" do
      to_js( 'a.last' ).must_equal 'a[a.length - 1]'
      to_js( 'a.last(n)' ).must_equal 'a.slice(a.length - n, a.length)'
    end

    it "should handle literal negative offsets" do
      to_js( 'a[-2]' ).must_equal 'a[a.length - 2]'
    end

    it "should handle inclusive ranges" do
      to_js( 'a[2..4]' ).must_equal 'a.slice(2, 5)'
      to_js( 'a[2..-1]' ).must_equal 'a.slice(2, a.length)'
      to_js( 'a[-4..-2]' ).must_equal 'a.slice(a.length - 4, a.length - 1)'
    end

    it "should handle exclusive ranges" do
      to_js( 'a[2...4]' ).must_equal 'a.slice(2, 4)'
      to_js( 'a[-4...-2]' ).must_equal 'a.slice(a.length - 4, a.length - 2)'
    end

    it "should handle regular expression indexes" do
      to_js( 'a[/\d+/]' ).must_equal 'a.match(/\d+/)[0]'
      to_js( 'a[/(\d+)/, 1]' ).must_equal 'a.match(/(\d+)/)[1]'
    end

    it "should handle empty?" do
      to_js( 'a.empty?' ).must_equal 'a.length == 0'
    end

    it "should handle nil?" do
      to_js( 'a.nil?' ).must_equal 'a == null'
    end

    it "should handle clear" do
      to_js( 'a.clear()' ).must_equal 'a.length = 0'
    end

    it "should handle replace" do
      to_js( 'a.replace(b)' ).
        must_equal 'a.length = 0; a.push.apply(a, b)'
    end

    it "should handle include?" do
      to_js( 'a.include? b' ).must_equal 'a.indexOf(b) != -1'
    end

    it "should handle any?" do
      to_js( 'a.any? {|i| i==0}' ).
        must_equal 'a.some(function(i) {return i == 0})'
    end

    it "should handle map" do
      to_js( 'a.map {|i| i+1}' ).
        must_equal 'a.map(function(i) {return i + 1})'
    end

    it "should handle all?" do
      to_js( 'a.all? {|i| i==0}' ).
        must_equal 'a.every(function(i) {return i == 0})'
    end

    it "should handle max" do
      to_js( 'a.max' ).must_equal 'a.max'
      to_js( 'a.max()' ).must_equal 'Math.max.apply(Math, a)'
    end

    it "should handle min" do
      to_js( 'a.min' ).must_equal 'a.min'
      to_js( 'a.min()' ).must_equal 'Math.min.apply(Math, a)'
    end

    it "should map .select to .filter" do
      to_js( 'a.select {|item| item > 0}' ).
        must_equal 'a.filter(function(item) {return item > 0})'
    end

    it "should map .select! to .splice(0, .length, .filter)" do
      to_js( 'a.select! {|item| item > 0}' ).
        must_equal 'a.splice.apply(a, [0, a.length].concat(a.filter(function(item) {return item > 0})))'
    end

    it "should map .map! to .splice(0, .length, .map)" do
      to_js( 'a.map! {|item| -item}' ).
        must_equal 'a.splice.apply(a, [0, a.length].concat(a.map(function(item) {return -item})))'
    end

    it "should map .reverse! to .splice(0, .length, .reverse)" do
      to_js( 'a.reverse!()' ).
        must_equal 'a.splice.apply(a, [0, a.length].concat(a.reverse()))'
    end
  end

  describe 'hash functions' do
    it "should handle keys" do
      to_js( 'a.keys' ).must_equal 'a.keys'
      to_js( 'a.keys()' ).must_equal 'Object.keys(a)'
    end

    it "should handle delete" do
      to_js( 'a.delete "x"' ).must_equal 'delete a["x"]'
    end
  end

  describe 'setTimeout/setInterval' do
    it "should handle setTimeout with first parameter passed as a block" do
      to_js( 'setInterval(100) {x()}' ).
        must_equal 'setInterval(function() {x()}, 100)'
    end

    it "should handle setInterval with first parameter passed as a block" do
      to_js( 'setInterval(100) {x()}' ).
        must_equal 'setInterval(function() {x()}, 100)'
    end
  end

  describe 'block-pass' do
    it 'should handle properties' do
      to_js( 'a.all?(&:ready)' ).
        must_equal 'a.every(function(item) {return item.ready})'
    end

    it 'should handle well known methods' do
      to_js( 'a.map(&:to_i)' ).
        must_equal 'a.map(function(item) {return parseInt(item)})'
    end

    it 'should handle binary operators' do
      to_js( 'a.sort(&:<)' ).
        must_equal 'a.sort(function(a, b) {return a < b})'
    end

    it 'should handles loops' do
      to_js( 'loop {sleep 1; break}').
        must_equal 'while (true) {sleep(1); break}'
    end
  end

  describe 'subclassing Exception' do
    it 'should create an Exception contructor' do
      to_js( 'class E < Exception; end' ).
        must_equal 'function E(message) {this.message = message; ' +
          'this.name = "E"; this.stack = Error(message).stack()}; ' +
          'E.prototype = Object.create(Error); E.prototype.constructor = E'
    end
  end

  describe Ruby2JS::Filter::DEFAULTS do
    it "should include Functions" do
      Ruby2JS::Filter::DEFAULTS.must_include Ruby2JS::Filter::Functions
    end
  end
end

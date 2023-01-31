require 'open-uri'
require 'nokogiri'
require 'csv'

def scraping(url)
    html = URI.open("#{url}")
    nokogiri_doc = Nokogiri::HTML(html)
    final_array = []

    nokogiri_doc.css('.s-asin').each do |element|
        title = element.css('.s-title-instructions-style').text
        price = element.css('.a-offscreen').text
        final_array << [title, price]
    end

    final_array.each_with_index do |element, index|
        puts "#{index + 1} - #{element}"
    end
end

scraper = scraping('https://www.amazon.pl/s?k=rtx+3080+ti&__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3V78HWTSJH455&sprefix=rtx+3080+ti%2Caps%2C105&ref=nb_sb_noss_1')

filepath = "amazon_rtx_3080_ti.csv"

CSV.open(filepath, 'wb') do |csv|
    csv << ['index', 'title', 'price']
    scraper.each_with_index do |item, index|
        csv << [index, item[0], item[1]]
    end
end
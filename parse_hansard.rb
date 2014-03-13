# encoding: UTF-8
require 'nokogiri'

doc = Nokogiri::HTML(open('test_hansard.htm', "r:UTF-8"), nil, 'UTF-8')

paragraphs = doc.css('div > p')


puts "Found #{paragraphs.size} paragraphs."

new_capture = true
captures = []
capture_index = -1

speakers = Hash.new { |hash, key| hash[key] = [] }

speaking = [ "Madam Speaker", "Mayor Katz", "Councillor Sharma", "Councillor Browaty", "Councillor Eadie", "Councillor Fielding", "Councillor Gerbasi", "Councillor Havixbeck", "Councillor Mayes", "Councillor Nordman", "Councillor Orlikow", "Councillor Pagtakhan", "Councillor Smith", "Councillor Steen", "Councillor Swandel", "Councillor Vandal", "Councillor Wyatt"]

paragraphs.each do |p|
  children = p.children
  #
  #puts "Para has #{children.size} children: "
  #children.each_with_index {|c, i| puts "Index #{i}"; puts c }
  
  spans = p.css('span')
  
  new_capture = capture_index == -1 || (!spans.size.zero? && spans[0].content.include?(':'))
  
  if new_capture
    speaker = "Unknown"
    capture_index += 1
    
    unless spans.size.zero? || !spans[0].content.include?(':')
      speaker = spans[0].content.chomp(' ').chomp(':')
        speakers[speaker].push(capture_index)
      
    end
    
    captures[capture_index] = { speaker: speaker, content: "" }
    new_capture = false
  end
  
  p.children.each do |child|
    #puts child.content
    captures[capture_index][:content] += child.content + " "   unless child.name == 'span' # This span rejection is too heavy a hammer. Strips out some required details.
    #puts captures[capture_index][:content]
  end
end

speaking.each do |s|
  word_count = 0
  speakers[s].each do |words_index|
    words = captures[words_index][:content]
    words = words.sub("…"," ")
    wc = words.split(' ')
    word_count += wc.size
  end
  #
  #puts "#{s} spoke #{speakers[s].count} times with #{word_count} words."
  print "<div class='speaker_wc'>"
  print "<img src='images/#{s.sub(' ','')}.jpg' title='#{s}' alt='#{s}'>"
  print "<div class='wc' style='width: #{(word_count/4.0).round}px;'>#</div>"
  print "<div class='words'>#{word_count} words<br>#{s}</div>"
  puts "</div>"
end

#target = File.open('output.htm', 'w:UTF-8')
#
#target.write("<!DOCTYPE html>
#<html>
#<head>
#  <title>Page Title</title>
#  <meta charset='utf-8'>
#</head>
#<body>")
#
#captures.each do |c|
#  target.write("<div class='speaker'>\n")
#  target.write("<div class='image'>\n")
#  if speaking.include?(c[:speaker])
#    target.write("<img src='images/#{c[:speaker].sub(' ','')}.jpg'>")
#  else
#    target.write("<img src='images/missing.jpg'>")
#  end
#  target.write("<p>#{c[:speaker]}</p>\n")
#  target.write("</div>\n")
#  target.write("<p>#{c[:content]}</p>\n")
#  puts c[:content]
#  target.write("</p>")
#  target.write("</div>")
#end
#
#target.write('</body></html>')
#
#target.close
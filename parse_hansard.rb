require 'nokogiri'

if ARGV.size != 2
  puts "Missing required arguments!"
  puts "Example: #{$0} input.html output.html"
  exit
end

input_file = ARGV[0]
output_file = ARGV[1]
doc = Nokogiri::HTML(open(input_file, "r:UTF-8"), nil, 'UTF-8')

paragraphs = doc.css('div > p')

puts "Found #{paragraphs.size} paragraphs."

attendees = ["Mayor Katz", "Councillor Sharma", "Councillor Browaty", "Councillor Eadie", "Councillor Fielding", "Councillor Gerbasi", "Councillor Havixbeck", "Councillor Mayes", "Councillor Nordman", "Councillor Orlikow", "Councillor Pagtakhan", "Councillor Smith", "Councillor Steen", "Councillor Swandel", "Councillor Vandal", "Councillor Wyatt"]

new_capture = true
captures = []
capture_index = -1

speakers = Hash.new { |hash, key| hash[key] = [] }

paragraphs.each do |p|
  children = p.children
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
    content = child.content
    content.gsub!(/:/, "<span class='highlight1'>:</span>")  unless child.name == 'span'
    content.gsub!(/Motion No/, "<span class='highlight2'>Motion No</span>")
    content.gsub!(/([A-Z ]{6,})/, '<span class=\'highlight3\'>\1</span>')
    captures[capture_index][:content] += content + " "
  end
end

target = File.open(output_file, 'w:UTF-8')

target.write("<!DOCTYPE html>
<html>
<head>
  <title>Parsed Hansard - #{input_file}</title>
  <meta charset='utf-8'>
  <style>
    span.highlight1 { background: #FAF741; padding: 0 2px; }
    span.highlight2 { background: #A1FF96; }
    span.highlight3 { background: #96FFC9; }
  </style>
</head>
<body>
<form>
  <label>Date:</label>
  <input type='text' name='date'>
  <label>Time:</label>
  <input type='text' name='time'>
  <label>Prayer by:</label>
  <input type='text' name='prayer_by'>
  <label>Meeting Speaker:</label>
  <input type='text' name='meeting_speaker'>
  <br>")
attendees.each do |attendee|
  attendee_snake_case = attendee.gsub(' ','_')
  target.write("<label for='#{attendee_snake_case}'>#{attendee}</label>")
  target.write("<input type='checkbox' checked name='present' value='#{attendee}' id='#{attendee_snake_case}'>\n")
end
  
target.write("</form>")

captures.each do |c|
  target.write("<div>\n")
  target.write("<p>#{c[:content]}</p>\n")
  target.write("<form>\n")
  target.write("<label>Speaker:</label>")
  target.write("<input type='text' name='speaker' value='#{c[:speaker]}'>\n")
  target.write("<label>Spoken:</label>")
  target.write("<input type='text' name='spoken'>\n")
  target.write("<button class='mute'>mute</button>\n")
  target.write("<button class=''>+ speaker</button>\n")
  target.write("<button class='mute'>+ motion</button>\n")
  target.write("</form>\n")
  target.write("</div>\n")
end

target.write('</body></html>')
target.close
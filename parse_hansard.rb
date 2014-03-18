require 'nokogiri'
require 'cgi'

attendees = ["Mayor Katz", "Councillor Sharma", "Councillor Browaty", "Councillor Eadie", "Councillor Fielding", "Councillor Gerbasi", "Councillor Havixbeck", "Councillor Mayes", "Councillor Nordman", "Councillor Orlikow", "Councillor Pagtakhan", "Councillor Smith", "Councillor Steen", "Councillor Swandel", "Councillor Vandal", "Councillor Wyatt"]

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

new_capture = true
captures = []
capture_index = -1

paragraphs.each do |p|
  spans = p.css('span')
  
  new_capture = capture_index == -1 || (!spans.size.zero? && spans[0].content.include?(':'))
  
  if new_capture
    speaker = "Unknown"
    capture_index += 1
    
    unless spans.size.zero? || !spans[0].content.include?(':')
      speaker = spans[0].content.chomp(' ').chomp(':')
    end
    
    captures[capture_index] = { speaker: speaker, content_html: "", content_raw: "" }
    new_capture = false
  end
  
  p.children.each do |child|
    content_raw = CGI.escapeHTML(child.content)
    content_html = content_raw
    content_html = content_html.gsub(/:/, "<span class='highlight1'>:</span>")  unless child.name == 'span'
    content_html = content_html.gsub(/Motion No/, "<span class='highlight2'>Motion No</span>")
    content_html = content_html.gsub(/([A-Z ]{6,})/, '<span class=\'highlight3\'>\1</span>')
    captures[capture_index][:content_raw] += content_raw + " "  unless child.name == 'span'
    captures[capture_index][:content_html] += content_html + " "
  end
end

target = File.open(output_file, 'w:UTF-8')

target.write("<!DOCTYPE html>
<html>
<head>
  <title>Parsed Hansard - #{input_file}</title>
  <meta charset='utf-8'>
  <link rel='stylesheet' href='main.css'>
  <script type='text/javascript' src='main.js'></script>
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
  <input type='text' name='meeting_speaker'>")


  
target.write("</form>\n")

captures.each do |c|
  target.write("<div>\n")
  target.write("<p>#{c[:content_html]}</p>\n")
  target.write("<form>\n")
  target.write("<label>Speaker:</label>")
  target.write("<input type='text' name='speaker' value='#{c[:speaker]}'>\n")
  target.write("<label>Spoken:</label>")
  target.write("<textarea name='spoken'>#{c[:content_raw]}</textarea>\n") # Using double quotes for value since content may include single quotes.
  target.write("<button class='confirm'>confirm</button>\n")
  target.write("<button class='mute'>mute</button>\n")
  target.write("<button class='add_speaker'>+ speaker</button>\n")
  target.write("<button class='add_motion'>+ motion</button>\n")
  target.write("<button class='add_vote'>+ vote</button>\n")
  target.write("<button class='add_section'>+ section</button>\n")
  target.write("</form>\n")
  target.write("</div>\n")
end

target.write("<h2>Attendance</h2>\n")
target.write("<form>\n")
attendees.each do |attendee|
  attendee_snake_case = attendee.gsub(' ','_')
  target.write("<label for='#{attendee_snake_case}'>#{attendee}</label>")
  target.write("<input type='checkbox' name='present' value='#{attendee}' id='#{attendee_snake_case}'>\n")
end
target.write("</form>\n")

target.write('</body></html>')
target.close
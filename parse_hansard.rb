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
    if capture_index > 0 # Remove speaker's name from the front of the captured raw contents of previous index.
      captures[capture_index][:content_raw].gsub!(/^#{captures[capture_index][:speaker]}:\s+/, "")
    end
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
    captures[capture_index][:content_raw] += content_raw + " "  # unless child.name == 'span' # Why was this span removal here? It's messing things up.
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
  <script type='text/javascript' src='jzed.js'></script>
  <script type='text/javascript' src='main.js'></script>
</head>
<body>
<section class='meta'>
  <form data-capture-type='object'>
    <label>Date:</label>
    <input class='capture' type='text' name='date'>
    <label>Time:</label>
    <input class='capture' type='text' name='time'>
    <label>Prayer by:</label>
    <input class='capture' type='text' name='prayer_by'>
    <label>Meeting Speaker:</label>
    <input class='capture' type='text' name='meeting_speaker'>
  </form>
</section>
<section class='hansard'>")


captures.each do |c|
  target.write("<form data-capture-type='array' data-key='speaker'>\n")
  target.write("<button class='next'>next</button>\n")
  target.write("<p>#{c[:content_html]}</p>\n")
  target.write("<label>Speaker:</label>")
  target.write("<input class='capture' type='text' name='name' value='#{c[:speaker]}'><br>\n")
  target.write("<label>Spoken:</label><br>")
  target.write("<textarea class='capture' name='spoken'>#{c[:content_raw]}</textarea>\n") # Using double quotes for value since content may include single quotes.
  target.write("<br><button class='mute'>mute</button>\n")
  target.write("<button class='add_speaker'>+ speaker</button>\n")
  target.write("<button class='add_motion'>+ motion</button>\n")
  target.write("<button class='add_vote'>+ vote</button>\n")
  target.write("<button class='add_section'>+ section</button>\n")
  target.write("</form>\n")
end

target.write("</section>
<h2>Attendance</h2>
<section class='attendance'>
<form data-capture-type='object'>\n")
attendees.each do |attendee|
  attendee_snake_case = attendee.gsub(' ','_')
  target.write("<label for='#{attendee_snake_case}'>#{attendee}</label>")
  target.write("<input class='capture' type='checkbox' checked='checked' value='#{attendee}' id='#{attendee_snake_case}'>\n")
end
target.write("</form>
</section>
<div>
  <h2>Generate JSON</h2>
  <textarea id='json_output'></textarea>
  <button id='build_json'>Build JSON</button>
</div>

<div class='hidden' id='speaker-template'>
  <form data-capture-type='array' data-key='speaker'>
  <button class='next'>next</button>
  <br>
  <label>Speaker:</label>
  <input class='capture' type='text' name='name' value=''>
  <br>
  <label>Spoken:</label>
  <br>
  <textarea class='capture' name='spoken'></textarea>
  <br>
  <button class='mute'>mute</button>
  <button class='add_speaker'>+ speaker</button>
  <button class='add_motion'>+ motion</button>
  <button class='add_vote'>+ vote</button>
  <button class='add_section'>+ section</button>
  </form>
</div>
<div class='hidden' id='motion-template'>
  <form data-capture-type='array' data-key='motion'>
  <button class='next'>next</button>
  <br>
  <label>Motion:</label>
  <input class='capture' type='text' name='name' value=''>
  <label>Moved by:</label>
  <input class='capture' type='text' name='moved_by' value=''>
  <label>Seconded by:</label>
  <input class='capture' type='text' name='seconded_by' value=''>
  <br>
  <label>Motion Text:</label>
  <br>
  <textarea class='capture' name='motion_text'></textarea>
  <br>
  <button class='mute'>mute</button>
  <button class='add_speaker'>+ speaker</button>
  <button class='add_motion'>+ motion</button>
  <button class='add_vote'>+ vote</button>
  <button class='add_section'>+ section</button>
  </form>
</div>
<div class='hidden' id='vote-template'>
  <form data-capture-type='array' data-key='vote'>
  <button class='next'>next</button>
  <br>
  <label>Vote:</label>
  <input class='capture' type='text' name='name' value=''>
  <label>Yeas:</label>
  <input class='capture' type='text' name='yeas' value=''>
  <label>Nays:</label>
  <input class='capture' type='text' name='nays' value=''>
  <label>Outcome:</label>
  <input class='capture' type='text' name='outcome' value=''>
  <br>
  <button class='mute'>mute</button>
  <button class='add_speaker'>+ speaker</button>
  <button class='add_motion'>+ motion</button>
  <button class='add_vote'>+ vote</button>
  <button class='add_section'>+ section</button>
  </form>
</div>
<div class='hidden' id='section-template'>
  <form data-capture-type='array' data-key='section'>
  <button class='next'>next</button>
  <br>
  <label>Section:</label>
  <input class='capture' type='text' name='name' value=''>
  <br>
  <button class='mute'>mute</button>
  <button class='add_speaker'>+ speaker</button>
  <button class='add_motion'>+ motion</button>
  <button class='add_vote'>+ vote</button>
  <button class='add_section'>+ section</button>
  </form>
</div>
</body>
</html>")
target.close

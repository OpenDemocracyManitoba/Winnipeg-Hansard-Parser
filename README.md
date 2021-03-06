# Winnipeg Council Hansard Parser

This tool is a collection of [Ruby](https://www.ruby-lang.org) and [Javascript](http://www.ecmascript.org/) programs that convert (PDF to JSON to HTML) the council meeting hansards posted on [the City of Winnipeg website](http://winnipeg.ca/clkdmis/DocSearch.asp?CommitteeType=C&DocumentType=H). 

## The Process Described

1. Download a hansard PDF from [the City of Winnipeg website](http://winnipeg.ca/clkdmis/DocSearch.asp?CommitteeType=C&DocumentType=H).
2. Convert the PDF to an HTML file using [HTML Publish](http://www.htmlpublish.com/convert-pdf-to-html/)\*.
3. Run the parse\_handsard.rb with the name of a converted HTML file from step 2 as the only argument.
4. Load the generated HTML file in a web-browser and fix any parsing errors.
5. Grab the resulting JSON.
6. Run the visualization script to convert the JSONified hansard into HTML meeting minutes.

\* If this service ever goes down it should be possible to use [BCL easyConverter SDK](http://www.pdfonline.com/easyconverter/sdk/) to perform this conversion.

## License

This is free and unencumbered software released into the public domain. See UNLICENSE for details.

# Extracting Data from Wpg Council MS-Word Documents

## Decision Making History at the City of Winnipeg

The Winnipeg City Clerk's department records the decision making history of all reports, motions, and by-laws that move through the city's [25+ committees](http://clkapps.winnipeg.ca/dmis/) using the Decision Making Information System, [DMIS](http://clkapps.winnipeg.ca/dmis/). 

There are four types of documents managed by the Clerk's departments using DMIS: 

1. Agenda - Produced ahead of the meeting with links to all the relevant reports, motions and bylaws.
2. Hansard - Full spoken transcription of meetings from closed-caption text.
3. Minutes - Similar in strcture to the Agenda with new decision history and action items added.
4. Dispositions - Recap of decisions on reports, motions and by-law's. 

Reports, motions and by-laws are tracked by the Clerk's department using Administration Reports attached to each item. The Admin Report shows the Critical Path (the item's flow through the various committees) and the decisions made about the item in those committees. For example a successful item's critical path might start in a community committee, flow up to EPC, get punted back to the community committee, back up to EPC and then through Council.

### Agendas

DMIS listings start as a file-folder of the reports, motions, bylaws and supporting material pertinent to a given meeting. Documents are usually Word, Excel or PDF. The first step is to build an Agenda structured as a table-of-contents for these documents. The hierarchy of the Agenda is mirrored in the Minutes and informs the Hansard and Disposition. 

### Minutes

Like the Agenda, but created after each meeting, Minutes begin as a folder full of documents. Documents are annotated with meeting decisions and required actions. The Admin Report of each document is updated and the Critical Path is adjusted if needed. For Word documents, the Admin Report is added/updated within the document itself.

### Disposition

A Disposition is compiled as a summary of report approvals, motion outcomes and by-law's passed. A fast turn-around is required on Dispositions (day-of if possible) to keep all of city hall informed on meeting decisions.

### Hansard

The creation of a full transcript of the meeting begins with a Word auto-format of the closed-caption text from ALL CAPS to normal punctuations. Clerks then read through the entire transcript to correct capitalization, fix spelling mistakes and mis-captions, and attempt to replace instances of "[inaudible]" with actual dialogue from the video. The ALL CAPS closed-caption version of the hansard is published right away. The final version reviewed by the Clerk's department is publish a few weeks later. Winnipeg is believed to be the only city in Canada that publishes a hansard for Council meetings. No other committees on DMIS have hansards.

## Sample DMIS Documents from the Clerk's Department

* [Hansard from 25-03-2015 Council Meeting](https://github.com/OpenDemocracyManitoba/Winnipeg-Hansard-Parser/blob/master/ms_word_council_docs/2015%2003%2025%20-%20Hansard.docx) - MS Word DOCX
* [Disposition from 25-03-2015 Council Meeting](https://github.com/OpenDemocracyManitoba/Winnipeg-Hansard-Parser/blob/master/ms_word_council_docs/D%202015%2003%2025.doc) - MS Word DOC
* [Minutes Index from 25-03-2015 Council Meeting](https://github.com/OpenDemocracyManitoba/Winnipeg-Hansard-Parser/blob/master/ms_word_council_docs/COUNCIL%20-%20INDEX.doc) - MS Word DOC

## Initial Technical Analysis

The hansard is saved as a DOCX format, which is zip/xml-based and should therefore be simple enough to parse. The disposition and minutes are in the older DOC format. They will need to be converted into DOCX before parsing. In the case of the minutes-index, which DMIS uses to build the table of contents for the Minutes, DOC might be the format expected by the DMIS code.

Some Ruby libraries of interest for creating and reading DOCX:

* [chrahunt/docx](https://github.com/chrahunt/docx) - Read DOCX paragraphs/bookmarks/tables. Insert text at bookmarks. Save changes.
* [zdavatz/ydocx](https://github.com/zdavatz/ydocx) - Parse DOCX files and output them as HTML.
* [senny/sablon](https://github.com/senny/sablon) - Insert datasets into DOCX templates using Ruby.
* [docxtor/docxtor](https://github.com/docxtor/docxtor) - DSL for building DOCX documents.
* [ffmike/docx_builder](https://github.com/ffmike/docx_builder) - Programatically build DOCX documents.

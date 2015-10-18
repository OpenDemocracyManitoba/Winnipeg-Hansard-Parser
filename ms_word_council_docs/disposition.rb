require 'docx'
require 'forwardable'

class Disposition
  extend Forwardable

  def initialize(filename)
    @doc = Docx::Document.open(filename)
  end

  def bylaws
    bylaw_data
  end

  def motions
   motion_data
  end

  private
  attr_reader :doc
  def_delegator :doc, :tables # This delegator isn't being made private. Is that possible?

  # BYLAWS

  def bylaw_table
    table_select('BY-LAWS PASSED (RECEIVED THIRD READING)')
  end

  def bylaw_table_rows
    bylaw_table.rows[2..-1] # The first two rows are headers
  end

  def bylaw_data
    bylaw_table_rows.map do |bylaw_row|
      { number:      bylaw_row.cells[0].text.strip,
        subject:     bylaw_row.cells[1].text.strip,
        disposition: bylaw_row.cells[2].text.strip }
    end
  end

  # MOTIONS
  #
  # * Motion table in document cannot be broken into multiple tables.
  # * Many motion subjects contain lists and other formatting. Currently this is ignore and converted to text only.

  def motion_table
    table_select('COUNCIL MOTIONS')
  end

  def motion_table_rows
    motion_table.rows[2..-1] # The first two rows are headers
  end

  def motion_data
    motion_table_rows.map do |motion_row|
      { number:      motion_row.cells[0].text.strip,
        movers:      motion_row.cells[1].text.strip,
        subject:     motion_row.cells[2].text.strip,
        disposition: motion_row.cells[3].text.strip }
    end
  end

  # HELPERS

  def table_select(heading)
    tables.select do |t|
      t.rows[0].cells[0].text == heading
    end.first
  end
end

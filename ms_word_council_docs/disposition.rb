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

  private
  attr_reader :doc
  def_delegator :doc, :tables # This delegator isn't being made private. Is that possible?

  def bylaw_table
    table_select('BY-LAWS PASSED (RECEIVED THIRD READING)')
  end

  def bylaw_table_rows
    bylaw_table.rows[2..-1] # The first two rows are headers
  end

  def bylaw_data
    bylaw_table_rows.map do |bylaw_row|
      { number:      bylaw_row.cells[0].text,
        subject:     bylaw_row.cells[1].text,
        disposition: bylaw_row.cells[2].text }
    end
  end

  def table_select(heading)
    tables.select do |t|
      t.rows[0].cells[0].text == heading
    end.first
  end
end

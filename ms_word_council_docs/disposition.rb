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
      { number:      bylaw_row.cells[0].text,
        subject:     bylaw_row.cells[1].text,
        disposition: bylaw_row.cells[2].text }
    end
  end

  # MOTIONS
  
  def motion_table
    table_select('COUNCIL MOTIONS')
  end

  def motion_table_rows
    motion_table.rows[2..-1] # The first two rows are headers
  end

  def motion_data
    motion_table_rows.map do |motion_row|
      {}
    end
  end

  # HELPERS

  def table_select(heading)
    tables.select do |t|
      t.rows[0].cells[0].text == heading
    end.first
  end
end

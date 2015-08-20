require 'docx'

class Hansard
  def initialize(filename)
    @doc = Docx::Document.open(filename)
  end

  def paragraphs
    doc.paragraphs
  end

  private
  attr_reader :doc
end

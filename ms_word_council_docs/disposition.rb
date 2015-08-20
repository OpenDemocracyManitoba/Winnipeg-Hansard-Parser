require 'docx'

class Disposition
  def initialize(filename)
    @doc = Docx::Document.open(filename)
  end

  private
  attr_reader :doc
end

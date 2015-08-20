require 'docx'
require 'forwardable'

class Hansard
  extend Forwardable
  
  def initialize(filename)
    @doc = Docx::Document.open(filename)
  end

  def_delegator :doc, :paragraphs

  private
  attr_reader :doc
end

class ProgressesController < ApplicationController
  def new
    @progress = Progress.new
    @question = Question.first
  end
end

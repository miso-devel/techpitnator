class GamesController < ApplicationController
  def new; end
  def create
    Game.create!(status: 'in_progress')
    redirect_to(games_test_path)
  end
  def test; end
end

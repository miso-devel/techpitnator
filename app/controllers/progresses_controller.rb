class ProgressesController < ApplicationController
  def new
    @progress = Progress.new
    @question = Question.first
  end

  def create
    # paramsからgame_idを取ってくる
    current_game = Game.find(params[:game_id])

    # (create_params)で許可された値のみでProgressモデルのインスタンス作成
    progress = current_game.progresses.new(create_params)

    # モデルにassign_sequenceメソッドについて書いてある
    progress.assign_sequence
    progress.save!
    redirect_to new_game_progresses_path(current_game)
  end

  private

  def create_params
    params.require(:progress).permit(:question_id, :answer)
  end
end

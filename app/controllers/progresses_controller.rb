class ProgressesController < ApplicationController
  def new
    @progress = Progress.new
    current_game = Game.find(params[:game_id])
    @question = Question.next_question(current_game)
  end

  def create
    # paramsからgame_idを取ってくる
    current_game = Game.find(params[:game_id])

    #(create_params)で許可された値のみでProgressモデルのインスタンス作成
    # current_gameからgame_idを取ってきてる、かつcreate_paramsでanswerとquestion_idを入れている
    progress = current_game.progresses.new(create_params)

    #モデルにassign_sequenceメソッドについて書いてある
    progress.assign_sequence
    progress.save!

    # 絞り込み
    @extract_comics = ExtractionAlgorithm.new(current_game).compute

    if @extract_comics.count == 0
      redirect_to give_up_game_path(current_game)
      return
    elsif @extract_comics.count == 1
      redirect_to challenge_game_path(current_game)
      return
    else
      next_question = Question.next_question(current_game)

      # 次の質問がないと終わる
      if next_question.blank?
        current_game.status = 'finished'
        current_game.result = 'incorrect'
        current_game.save!
        redirect_to give_up_game_path(current_game)
        return
      end

      # 次の質問へ行く
      redirect_to new_game_progresses_path(current_game)
    end
  end

  private

  def create_params
    params.require(:progress).permit(:question_id, :answer)
  end
end

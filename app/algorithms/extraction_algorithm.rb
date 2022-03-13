class ExtractionAlgorithm
  attr_reader :game
  attr_reader :query

  def initialize(game)
    Rails.logger.debug('ExtractionAlgorithm initialized.')
    @game = game
    @query = Comic.all
  end

  # 絞り込みメソッド（）
  def serialization_end?(progress)
    # はいと答えた場合
    if progress.positive_answer?
      # comics.serialization_end_yearがnullでないものをqueryに代入
      @query = @query.where.not('comics.serialization_end_year is null')
    end

    # いいえと答えた場合
    if progress.negative_answer?
      # comics.serialization_end_yearがnullのものをqueryに代入
      @query = @query.where('comics.serialization_end_year is null')
    end
  end

  # 絞り込みメソッド(ジャンル)
  def genre_match(progress)
    if progress.positive_answer?
      # progress.question.eval_valueを含んでいるもの
      @query =
        @query.where('comics.genre like ?', "%#{progress.question.eval_value}%")
    end

    if progress.negative_answer?
      # progress.question.eval_valueを含んでいないもの
      @query =
        @query.where.not(
          'comics.genre like ?',
          "%#{progress.question.eval_value}%",
        )
    end
  end

  def compute
    # gameはprogressesは1対Nでリレーションされている
    progresses = @game.progresses
    progresses.each do |progress|
      # question
      question = progress.question

      case question.algorithm
      when 'serialization_end'
        serialization_end?(progress)
      when 'genre_match'
        genre_match(progress)
      else
        # 例外処理
        raise Exception.new('Invalid algorithm. --> ' + question.algorithm.to_s)
      end

      Rails.logger.debug('On the way query is ' + @query.to_sql.to_s)
      Rails.logger.debug(
        'On the way comics are ' + @query.pluck(:title).to_a.to_s,
      )
    end
    @query
  end
end

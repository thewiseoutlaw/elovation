class ResultsController < ApplicationController
  before_action :set_game

  def create
    max_count = 3
    win_count = params[:result][:teams][:win_count].to_i
    lose_count = 3-win_count
    for i in 0..win_count
      response = ResultService.create(@game, params[:result])
    end
    for i in 0..lose_count
      win_team = params[:result][:teams][0]
      lose_team = params[:result][:teams][1]
      params[:result][:teams][0]=lose_team
      params[:result][:teams][1]=win_team
      response = ResultService.create(@game, params[:result])
    end
    response = ResultService.create(@game, params[:result])
    if response.success?
      redirect_to game_path(@game)
    else
      @result = response.result
      render :new
    end
  end

  def destroy
    result = @game.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    @result = Result.new
    (@game.max_number_of_teams || 10).times{|i| @result.teams.build rank: i}
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end

class ResultsController < ApplicationController
  before_action :set_game

  def create
    params[:results].each do |result|
      response = ResultService.create(@game, result)
      if response.success?
        redirect_to game_path(@game)
      else
        @result = response.result
        render :new
      end
    end
  end

  def destroy
    result = @game.results.find_by_id(params[:id])

    response = ResultService.destroy(result)

    redirect_to :back
  end

  def new
    #Matches are out of 3 games
    MATCH=3
    @results=[]
    for y in 0..MATCH
      @results.push(Result.new)
    end
    @results.each do |result|
      (@game.max_number_of_teams || 10).times{|i| result.teams.build rank: i}
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end

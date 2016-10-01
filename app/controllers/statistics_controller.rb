class StatisticsController < ApplicationController
  def index
    @articles = Article.all
    @marks = [0,0,0,0]
    @articles.each do |article|
      case article.mark
      when "2"
        @marks[0] = @marks[0]+1
      when "3"
        @marks[1] = @marks[1]+1
      when "4"
        @marks[2] = @marks[2]+1
      when "5"
        @marks[3] = @marks[3]+1
      end
    end
    @maxind = @marks.max
  end
end

class TwitterController < ApplicationController
  helper_method :sort_column, :sort_direction
  

  def index
    # @stats = TwitterStat.join_org_and_sort(sort_column, sort_direction).paginate(:per_page => 50, :page => params[:page])
    @links = Link.twitter
      .sortable(sort_column, sort_direction)
      .paginate(:per_page => 50, :page => params[:page])
  end

  private

  def sort_column
   Link.sortable_columns.include?(params[:sort]) ? params[:sort] : Link.sortable_columns.first
  end

  def sort_direction
    Link.sortable_directions.include?(params[:direction]) ? params[:direction] : Link.sortable_directions.first
  end
end
class EntriesController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def index
    @list = List.find(params[:list_id])
    @entries = find_entries_by_list(@list)
    @entry = Entry.new
  end

  def show
    @list = List.find.find(params[:list_id])
    @entry = @list.entries.find(params[:id])
  end

  def new
    @list = current_user.lists.find(params[:list_id])
    @entry = Entry.new
  end

  def edit
    @list = List.find(params[:list_id])
    @entry = @list.entries.find(params[:id])
  end

  def create
    @list = List.find(params[:list_id])
    @entry = @list.entries.build(params[:entry])
    @entry = @list.entries.build if @entry.save
      
    @entries = find_entries_by_list(@list)
  end

  def update
    @list = List.find(params[:list_id])
    @entry = @list.entries.find(params[:id])
    @entry = Entry.new if @entry.update_attributes(params[:entry])
      
    @entries = find_entries_by_list(@list)
  end

  def destroy
    @list = List.lists.find(params[:list_id])
    @entry = Entry.find(params[:id])
    @entry = Entry.new if @entry.destroy
    
    @entries = find_entries_by_list(@list)
  end
  
  
  private
  
  
  def find_entries_by_list(list)
    list.entries.where(:list_id => params[:list_id]).all
  end
  
  def sort_column
    %w(priority title deadline).include?(params[:sort]) ? params[:sort] : 'priority'
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
end

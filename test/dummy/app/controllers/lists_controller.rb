class ListsController < ApplicationController
  def index
    dq = dynamic_query(List, Entry, :alias => { 'lists.name' => 'Full Name' })
    @panel = dq.panel(params[:query])
    @lists = List.where(dq.statement(params[:query])).all
    @list = List.new
  end

  def show
    @list = List.find(params[:id])
  end

  def new
    @list = List.new
  end

  def edit
    @list = List.find(params[:id])
  end

  def create
    @list = List.new(params[:list])
    @list = List.new if @list.save
    
    @lists = List.all
  end

  def update
    @list = List.find(params[:id])
    @list = List.new if @list.update_attributes(params[:list])

    @lists = List.all
  end
  
  def destroy
    @list = List.find(params[:id])
    @list = List.new if @list.destroy

    @lists = List.all
  end
end

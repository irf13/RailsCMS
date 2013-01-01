class SectionsController < ApplicationController

  layout 'admin'

  #localhost:3000/sections  -- when there is no id
  def index
    list              #call the action
    render('list')    #render the correct template not 'index'
  end
  
  def list
    @sections = Section.order("sections.position ASC")
  end
  
  def show
    #Section.find(1)
    @section = Section.find(params[:id])
  end
  
  def new
    @section = Section.new
    @section.name = "default"
    @section_count = Section.count + 1
    @pages = Page.order('position ASC')
  end
  
  #No need for a template here - redirected either way
  def create
    #Instantiate a new object using form parameters
    @section = Section.new
    @section.name = params[:section][:name]
    @section.position = params[:section][:position]
    @section.visible = params[:section][:visible]
    @section.content_type = params[:section][:content_type]
    @section.content = params[:section][:content]
    
    #Save the object
    if @section.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Section created."
      redirect_to(:action => 'list')
    else
      #If save fails, redisplay the form so user can fix problem
      @section_count = Section.count + 1
      @pages = Page.order('position ASC')
      render('new')
    end
  end
  
  def edit
    @section = Section.find(params[:id])
    @section_count = Section.count 
    @pages = Page.order('position ASC') 
  end
  
  def update
    #Find a new object using form parameters
    @section = Section.find(params[:id])
    @section.name = params[:section][:name]
    @section.position = params[:section][:position]
    @section.visible = params[:section][:visible]
    @section.content_type = params[:section][:content_type]
    @section.content = params[:section][:content]
    
    #Update the object
    if @section.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Section updated."
      redirect_to(:action => 'show', :id => @section.id)
    else
      #If save fails, redisplay the form so user can fix problem
      @section_count = Section.count 
      @pages = Page.order('position ASC')
      render('edit')
    end
  end
  
  def delete
    @section = Section.find(params[:id])
  end
  
  
  def destroy
    Section.find(params[:id]).destroy
    flash[:notice] = "Section destroyed."
    redirect_to(:action => 'list')
  end

end

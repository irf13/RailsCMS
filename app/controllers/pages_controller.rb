class PagesController < ApplicationController
  
  layout 'admin'
  
  #localhost:3000/pages  -- when there is no id
  def index
    list              #call the action
    render('list')    #render the correct template not 'index'
  end
  
  def list
    @pages = Page.order("pages.position ASC")
  end
  
  def show
    #Page.find(1)
    @page = Page.find(params[:id])
  end
  
  def new
    @page = Page.new
    @page.name = "default"
    @page_count = Page.count + 1
    @subjects = Subject.order('position ASC')
  end
  
  #No need for a template here - redirected either way
  def create
    #Instantiate a new object using form parameters
    @page = Page.new
    @page.name = params[:page][:name]
    @page.position = params[:page][:position]
    @page.visible = params[:page][:visible]
    
    #Save the object
    if @page.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Page created."
      redirect_to(:action => 'list')
    else
      #If save fails, redisplay the form so user can fix problem
      @page_count = Page.count + 1
      @subjects = Subject.order('position ASC')
      render('new')
    end
  end
  
  def edit
    @page = Page.find(params[:id])
    @page_count = Page.count
    @subjects = Subject.order('position ASC')
  end
  
  def update
    #Find a new object using form parameters
    @page = Page.find(params[:id])
    @page.name = params[:page][:name]
    @page.position = params[:page][:position]
    @page.visible = params[:page][:visible]
    
    #Update the object
    if @page.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Page updated."
      redirect_to(:action => 'show', :id => @page.id)
    else
      #If save fails, redisplay the form so user can fix problem
      @page_count = Page.count
      @subjects = Subject.order('position ASC')
      render('edit')
    end
  end
  
  def delete
    @page = Page.find(params[:id])
  end
  
  
  def destroy
    Page.find(params[:id]).destroy
    flash[:notice] = "Page destroyed."
    redirect_to(:action => 'list')
  end

end

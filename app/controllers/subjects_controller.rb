class SubjectsController < ApplicationController
  
  layout 'admin'
  
  #localhost:3000/subjects  -- when there is no id
  def index
    list              #call the action
    render('list')    #render the correct template not 'index'
  end
  
  def list
    @subjects = Subject.order("subjects.position ASC")
  end
  
  def show
    #Subject.find(1)
    @subject = Subject.find(params[:id])
  end
  
  def new
    @subject = Subject.new
    @subject.name = "default"
    @subject_count = Subject.count + 1
  end
  
  #No need for a template here - redirected either way
  def create
    #Instantiate a new object using form parameters
    @subject = Subject.new
    @subject.name = params[:subject][:name]
    @subject.position = params[:subject][:position]
    @subject.visible = params[:subject][:visible]
    
    #Save the object
    if @subject.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Subject created."
      redirect_to(:action => 'list')
    else
      #If save fails, redisplay the form so user can fix problem
      @subject_count = Subject.count + 1
      render('new')
    end
  end
  
  def edit
    @subject = Subject.find(params[:id])
    @subject_count = Subject.count
  end
  
  def update
    #Find a new object using form parameters
    @subject = Subject.find(params[:id])
    @subject.name = params[:subject][:name]
    @subject.position = params[:subject][:position]
    @subject.visible = params[:subject][:visible]
    
    #Update the object
    if @subject.save
      #If the save succeeds, redirect to the list action
      flash[:notice] = "Subject updated."
      redirect_to(:action => 'show', :id => @subject.id)
    else
      #If save fails, redisplay the form so user can fix problem
      @subject_count = Subject.count 
      render('edit')
    end
  end
  
  def delete
    @subject = Subject.find(params[:id])
  end
  
  
  def destroy
    Subject.find(params[:id]).destroy
    flash[:notice] = "Subject destroyed."
    redirect_to(:action => 'list')
  end

end
 
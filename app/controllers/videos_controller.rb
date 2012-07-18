class VideosController < ApplicationController
  before_filter :check_for_sign_in, :only => [:add_answer, :add_question, :vote]
  
  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
    @question = Question.new
    @answer = Answer.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :ok }
    end
  end
  
  def add_question
    @video = Video.find(params[:id])
    @question = @video.questions.create(:body => params[:question][:body], :user_id => current_user.id)
    @answer = Answer.new
  end
  
  def add_answer
    @question = Question.find(params[:id])
    @answer = @question.answers.create(:body => params[:answer][:body], :user_id => current_user.id)
  end
  
  def vote
    target = params[:target]
    id = params[:id]
    
    object = if target == 'v'
        Video.find id
      elsif target == 'a'
        Answer.find id
      elsif target == 'q'
        Question.find id
      end
    
    value = params[:type] == 'like' ? 1 : -1
    object.add_or_update_evaluation(:votes, value, current_user)
     
    total_votes 
    # object.vote :voter => current_user, :vote => params[:type]
    # total_votes = object.upvotes.size - object.downvotes.size
    
    voteType = (current_user.voted_down_on?(object)) ? 'down' : 'up'
    voteTypeInverse = (current_user.voted_down_on?(object)) ? 'up' : 'down'
    
    render :js => "$('##{target + id}-votes').html(#{total_votes});$('##{target + id}-votes-#{voteType}').addClass('vote-clicked');$('##{target + id}-votes-#{voteTypeInverse}').removeClass('vote-clicked');" 
  end
  
end

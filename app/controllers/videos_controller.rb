class VideosController < ApplicationController
  before_filter :check_for_sign_in, :only => [:add_answer, :add_question, :vote]
  # check_authorization
  
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
    @question = VideoQuestion.new
    @answer = VideoAnswer.new
    
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
    @question = VideoQuestion.new(:body => params[:video_question][:body], :user_id => current_user.id, :video_id => params[:id])
    
    @error_place = 'submit-question'
    
    authorize! :create, @question, :message => t('.can_not_ask')
    @answer = VideoAnswer.new
    
    save_or_show_error(@question)
  end
  
  def add_answer
    @question = VideoQuestion.find params[:id]
    @answer = VideoAnswer.new(:body => params[:video_answer][:body], :user_id => current_user.id, :video_question_id => params[:id])
    
    @error_place = "submit-ans-#{params[:id]}"
    authorize! :create, @answer, :message => t('.can_not_answer')
    
    save_or_show_error(@answer)
  end
  
  def vote
    target = params[:target]
    id = params[:id]
    
    target_map = {'v' => Video, 'a' => VideoAnswer, 'q' => VideoQuestion}
    object = target_map[target].find id
    
    @error_place = "#{params[:target] + params[:id]}-votes-#{params[:type]}"
    
    # check for not voting on his actions
    authorize! :vote, object, :message => t('.can_not_vote')
    
    # chech for being able to vote up or down
    if params[:type] == 'up'
      authorize! :vote_up, object.class, :message => t('.can_not_vote_up')
    else
      authorize! :vote_down, object.class, :message => t('.can_not_vote_down')
    end
    
    value = params[:type] == 'up' ? 1 : -1
    object.add_or_update_evaluation(:votes, value, current_user)
     
    total_votes = object.reputation_value_for(:votes) 
    
    # building the response script
    render :js => "$('##{target + id}-votes').html(#{total_votes});toggleVotes('#{target + id}', '#{params[:type]}');" 
  end
  
protected
  def save_or_show_error(object)
    display_error_popup(@error_place, (object.errors.messages[:body].join('and'))) unless object.save
  end
end

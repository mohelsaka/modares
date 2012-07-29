class VideosController < ApplicationController
  before_filter :check_for_sign_in, :only => [:add_answer, :add_question, :vote]
  before_filter :authenticate_user!, :only => [:new, :upload, :make_new_video, :gettoken]
  require 'youtube_it'
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
    @id = params[:id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end
  
  def upload
  end
  
  
  # this method is called on youtube callback is made
  # youtube callback contains video_id and video id on youtube
  # saves the video url to to our video 
  def make_new_video
    v = Video.find params[:video_id]
    v.url = params[:id]
    v.save
    redirect_to videos_url
  end
    
  def gettoken
    v = Video.new
    v.update_attributes(:user_id => current_user.id, :title => params[:token][:title], :description => params[:token][:description], :subject_id => params[:video][:subject_id])
    videoParams = {:title => params[:token][:title], :description => params[:token][:description], :category => 'Education', :keywords => ["Egypt"], :private => true}
    upload_info = User::CLIENT.upload_token(videoParams, "#{make_video_url}?video_id=#{v.id}")
    render :js => "uploadAjax('#{upload_info[:token]}','#{upload_info[:url]}')"
  end
  
  
  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])
    @video.user_id = current_user.id
    @video.views = 0 
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
    @question = Question.new(:body => params[:question][:body], :user_id => current_user.id, :video_id => params[:id])
    
    @error_place = 'submit-question'
    
    authorize! :create, @question, :message => t('.can_not_ask')
    @answer = Answer.new
    
    save_or_show_error(@question)
  end
  
  def add_answer
    @question = Question.find params[:id]
    @answer = Answer.new(:body => params[:answer][:body], :user_id => current_user.id, :question_id => params[:id])
    
    @error_place = "submit-ans-#{params[:id]}"
    authorize! :create, @answer, :message => t('.can_not_answer')
    
    save_or_show_error(@answer)
  end
  
  def vote
    target = params[:target]
    id = params[:id]
    
    target_map = {'v' => Video, 'a' => Answer, 'q' => Question}
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

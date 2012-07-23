class VideosController < ApplicationController
  before_filter :check_for_sign_in, :only => [:add_answer, :add_question, :vote]
  before_filter :authenticate_user!, :only => [:new]
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
    
    videoParams = {:title => "untitled",:description => "no description",:category => "Education",:keywords => ["Egypt"]}
    client = YouTubeIt::Client.new(:username => "el.modars", :password =>  "badritbadrit", :dev_key => "AI39si4h6XwXU6zlKnxqu_9-MYOAtGuuXZ2k5UjMFbxWViwuc1s_476v25nRjrlGvO1ullFSMmpUX6AaQwKmGft4ZXUnYFfhHA")    
    @upload_info = client.upload_token(videoParams, 'http://localhost:3000/videos/new?video_id=123')
  end
  
  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])
    client = YouTubeIt::Client.new(:username => "el.modars", :password =>  "badritbadrit", :dev_key => "AI39si4h6XwXU6zlKnxqu_9-MYOAtGuuXZ2k5UjMFbxWViwuc1s_476v25nRjrlGvO1ullFSMmpUX6AaQwKmGft4ZXUnYFfhHA")
    client.video_update(params[:video][:url], :title => params[:video][:title],:description => params[:video][:description], :category => 'People',:keywords => %w[cool blah test])
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

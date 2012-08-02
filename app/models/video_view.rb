class VideoView < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
end

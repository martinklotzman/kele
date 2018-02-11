require 'httparty'
require 'byebug'
require 'json'

module Roadmap

include HTTParty

  def get_roadmap(roadmap_id)
    #example 37
    response = self.class.get('https://www.bloc.io/api/v1/roadmaps/' + roadmap_id.to_s, headers: { "authorization": @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    #example 2227
    response = self.class.get('https://www.bloc.io/api/v1/checkpoints/' + checkpoint_id.to_s, headers: { "authorization": @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end

require 'httparty'
require 'byebug'
require 'json'

module Roadmap

@base_uri = 'https://www.bloc.io/api/v1'

include HTTParty

  def get_roadmap(roadmap_id)
    #example 37
    response = self.class.get(api_uri("/roadmaps/#{roadmap_id}"), headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    #example 2227
    response = self.class.get(api_uri("/checkpoints/#{checkpoint_id}"), headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  private

  def api_uri(path)
    "#{@base_uri}/#{path}"
  end
end

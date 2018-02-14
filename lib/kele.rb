require 'httparty'
require 'byebug'
require 'json'

class Kele

include HTTParty

  def initialize(email, password)
    @email = email
    @password = password
    @base_uri = 'https://www.bloc.io/api/v1'

    response = self.class.post("#{@base_uri}/sessions", body: { "email": @email, "password": @password})
    @auth_token = response[ "auth_token" ]

    if @auth_token.nil? || response.nil?
      raise Error, "Unable to access user. Please try again with valid user information."
    end
  end

  def get_me
    response = self.class.get("#{@base_uri}/users/me", headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  # id example = 2400043
  def get_mentor_availability(mentor_id)
    response = self.class.get("#{@base_uri}/mentors/#{mentor_id}/student_availability", headers: { "authorization": @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
end

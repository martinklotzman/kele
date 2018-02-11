require 'httparty'
require 'byebug'
require 'json'
require_relative 'roadmap'

class Kele

include HTTParty
include Roadmap

  def initialize(email, password)
    @email = email
    @password = password

    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { "email": @email, "password": @password})
    @auth_token = response[ "auth_token" ]

    if @auth_token.nil? || response.nil?
      raise Error, "Unable to access user. Please try again with valid user information."
    end
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability
    response = self.class.get('https://www.bloc.io/api/v1/mentors/2400043/student_availability', headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end
end

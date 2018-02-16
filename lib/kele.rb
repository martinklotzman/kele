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
    @base_uri = 'https://www.bloc.io/api/v1'

    response = self.class.post(api_uri("/sessions"), body: { "email": @email, "password": @password})
    @auth_token = response[ "auth_token" ]

    if @auth_token.nil? || response.nil?
      raise Error, "Unable to access user. Please try again with valid user information."
    end
  end

  def get_me
    response = self.class.get(api_uri("/users/me"), headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  # id example = 2400043
  def get_mentor_availability(mentor_id)
    response = self.class.get(api_uri("/mentors/#{mentor_id}/student_availability"), headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page == nil
      response = self.class.get(api_uri("/message_threads"), headers: { "authorization": @auth_token })
    else
      response = self.class.get(api_uri("/message_threads"), body: { "page": page }, headers: { "authorization": @auth_token })
    end
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post(api_uri("/messages"), body: { "sender": sender, "recipient_id": recipient_id, "token": token, "subject": subject, "stripped_text": stripped_text }, headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  private

  def api_uri(path)
    "#{@base_uri}/#{path}"
  end
end

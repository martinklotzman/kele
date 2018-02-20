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

  def create_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post(api_uri("/messages"), body: { "sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped_text": stripped_text }, headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id)
    response = self.class.post(api_uri("/checkpoint_submissions"), body: { "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment, "enrollment_id": enrollment_id }, headers: { "authorization": @auth_token })
    if response.success?
      puts "You have made a new submission."
    else
      puts "Something went wrong, please try again."
    end
  end

  private

  def api_uri(path)
    "#{@base_uri}/#{path}"
  end
end

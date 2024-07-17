# app/policies/follow_request_policy.rb

class FollowRequestPolicy < ApplicationPolicy
  attr_reader :user, :follow_request

  def initialize(user, follow_request)
    @user = user
    @follow_request = follow_request
  end

  def show?
    user == follow_request.sender || user == follow_request.recipient
  end

  def create?
    !user.nil?
  end

  def new?
    create?
  end

  def update?
    user == follow_request.sender
  end

  def edit?
    update?
  end

  def destroy?
    user == follow_request.sender || follow_request.recipient
  end

  class Scope < Scope
    def resolve
      scope.all.select do |follow_request|
        follow_request.sender == user || follow_request.recipient == user
      end
    end
  end
end

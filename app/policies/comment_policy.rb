# app/policies/comment_policy.rb

class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def show?
    user == comment.author || !comment.author.private? || comment.author.followers.include?(user)
  end

  def create?
    !user.nil?
  end

  def new?
    create?
  end

  def update?
    user == comment.author
  end

  def edit?
    update?
  end

  def destroy?
    user == comment.author
  end

  class Scope < Scope
    def resolve
      scope.all.select do |comment|
        comment.author == user || !comment.author.private? || comment.author.followers.include?(user)
      end
    end
  end
end

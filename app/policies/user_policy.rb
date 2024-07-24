# app/policies/user_policy.rb

class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def feed?
    true
  end
  
  def show?
    true
  end

  def show_photos?
    current_user == user || !user.private? || current_user.leaders.include?(user)
  end

  def update?
    current_user.admin? || user == current_user
  end

  def edit?
    update?
  end

  def destroy?
    current_user.admin? || user == current_user
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(private: false).or(scope.where(id: user.following_ids).or(scope.where(id: user.id)))
      end
    end
  end
end

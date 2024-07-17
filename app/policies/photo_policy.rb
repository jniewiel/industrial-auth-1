# app/policies/photo_policy.rb

class PhotoPolicy < ApplicationPolicy
  attr_reader :user, :photo

  def initialize(user, photo)
    @user = user
    @photo = photo
  end

  def show?
    user == photo.owner || !photo.owner.private? || photo.owner.followers.include?(user)
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user == photo.owner
  end

  def edit?
    update?
  end

  def destroy?
    user == photo.owner
  end

  class Scope < Scope
    def resolve
      scope.all.select do |photo|
        photo.owner == user || !photo.owner.private? || photo.owner.followers.include?(user)
      end
    end
  end
end

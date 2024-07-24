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
      if user.admin?
        scope.all
      else
        scope.joins(:owner).left_outer_joins(owner: :followers).where("photos.owner_id = :user_id OR owners.private = :false OR followers.user_id = :user_id", { :user_id => user.id, :false => false }).distinct
      end
    end
  end
end

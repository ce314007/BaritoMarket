class InfrastructurePolicy < ApplicationPolicy
  def show?
    return true if get_user_groups
  end

  def retry_bootstrap?
    show?
  end

  def toggle_status?
    return true if get_user_groups
    false
  end

  def exists?
    return true if get_user_groups and not @record.nil?
  end
end

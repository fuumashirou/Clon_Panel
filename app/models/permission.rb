class Permission < Struct.new(:user)
  def allow?(controller, action)
    if user && user.instance_of?(Manager)
      return true if controller == "stores" && action.in?(%w(index new create show edit update manage confirm))
    elsif user && user.instance_of?(Employee)
      return true if controller == "stores" && action.in?(%w(show))
    elsif user && user.instance_of?(Admin)
      return true
    end
    return true if controller == "stores" && action.in?(%w(new create))
    return true if controller == "pages"
    return false
  end
end

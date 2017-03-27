class LabelPolicy
  attr_reader :current_user, :label

  def initialize(current_user, model)
    @current_user = current_user
    @label = model
  end

  def index?
    @current_user.admin?
  end

  def show?
    index?
  end

  def create?
    @current_user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end

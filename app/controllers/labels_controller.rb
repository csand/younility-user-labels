class LabelsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @labels = Label.all
    authorize Label
  end

  def show
    @label = Label.find params[:id]
    authorize @label
  end

  def create
    authorize Label
    user = User.find params[:user][:id]
    label = Label.find_or_create_by(label_params)
    # TODO: Should have an unique index on labels_users
    if user.labels.include? label
      redirect_to user, notice: 'That label already exists on this user.'
    else
      user.labels << label
      redirect_to user, notice: "Label #{label.name} added to user."
    end
  end

  def destroy
    label = Label.find params[:id]
    authorize label
    label.destroy
    redirect_to labels_path, notice: 'Label deleted.'
  end

  private

  def label_params
    params.require(:label).permit(:name, :color)
  end
end

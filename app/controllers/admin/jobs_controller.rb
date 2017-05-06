class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_is_admin
  before_action :find_job_and_check_permission, only: [:edit, :update, :destroy]


  layout "admin"
  def show
    @job = Job.find(params[:id])
  end

  def index
    @jobs = Job.order("created_at DESC")
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      if params[:photos] != nil
        params[:photos]['avatar'].each do |a|
          @photo = @job.photoss.create(:avatar => a)
        end
      end
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if params[:photos] != nil
      @job.photos.destroy_all #need to destroy old pics first
      params[:photos]['avatar'].each do |a|
        @picture = @job.photos.create(:avatar => a)
      end
      @job.update(job_params)
      redirect_to admin_jobs_path
    elsif @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    redirect_to admin_jobs_path
  end

  def publish
    @job = Job.find(params[:id])
    @job.publish!
    redirect_to :back
  end

  def hide
    @job = Job.find(params[:id])
    @job.hide!
    redirect_to :back
  end



  private
  private
  def find_job_and_check_permission
    @job = Job.find(params[:id])

    if current_user != @job.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
  def job_params
    params.require(:job).permit(:title,:description, :wage_upper_bound, :wage_lower_bound, :contact_email,:is_hidden,:image)
  end
end

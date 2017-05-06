class JobsController < ApplicationController
before_action :authenticate_user!,  only: [:new, :create, :update, :edit, :destroy, :upvote, :downvote, :add_to_favorite, :quit_favorite ]
 before_action :validate_search_key, only: [:search]
 before_action :find_job_and_check_permission, only: [:edit, :update, :destroy]


  def index
    @jobs = case params[:order]
         when 'by_lower_bound'
           Job.published.order('wage_lower_bound DESC')
         when 'by_upper_bound'
           Job.published.order('wage_upper_bound DESC')
         else
           Job.published.recent
         end
    if params[:favorite] == "yes"
      @jobs = current_user.jobs
    end
  end


  def new
    @job = Job.new
    @photo = @job.photos.build #for multi-pics
  end

  def show
    @job = Job.find(params[:id])
    @photos = @job.photos.all
    if @job.is_hidden
      flash[:warning] = "This job already archieves"
      redirect_to root_path
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user
    if @job.save
      if params[:photos] != nil
         params[:photos]['avatar'].each do |a|
           @photo = @job.photos.create(:avatar => a)
         end
       end
      redirect_to jobs_path
    else
      render :new
    end
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

      redirect_to jobs_path
    end
    # 投票功能
    def upvote
      @job = Job.find(params[:id])
      if !current_user.is_voter_of?(@job)
        current_user.upvote!(@job)
      end
      redirect_to :back
    end
    def downvote
      @job = Job.find(params[:id])
      if current_user.is_voter_of?(@job)
        current_user.downvote!(@job)
      end
      redirect_to :back
    end
    #收藏
    def add_to_favorite
      @job = Job.find(params[:id])
      @job.users << current_user
      @job.save
      redirect_to :back, notice:"成功加入收藏!"
    end
    def quit_favorite
      @job = Job.find(params[:id])
      @job.users.delete(current_user)
      @job.save
      redirect_to :back, alert: "成功取消收藏!"
    end
# 搜索功能
    def search
        if @query_string.present?
          search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
          @jobs = search_result.paginate(:page => params[:page], :per_page => 5 )
        end
      end
      protected
      def validate_search_key
        @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
        if params[:q].present?
          @search_criteria = search_criteria(@query_string)
        end
      end
      def search_criteria(query_string)
        { :title_cont => query_string }
      end

    private
    def find_job_and_check_permission
      @job = Job.find(params[:id])

      if current_user != @job.user
        redirect_to root_path, alert: "You have no permission."
      end
    end

    def job_params
      params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :image,:kechengmingcheng, :zhangjie, :step)
    end
end

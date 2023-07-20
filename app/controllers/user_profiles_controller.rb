class UserProfilesController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :ensure_user, only:[:edit, :update]
  
  def new
    @user_profile = UserProfile.new
    @category_about_region = CategoryAboutRegion.new
    @category_incubation = CategoryIncubation.new
    @category_immigration_support = CategoryImmigrationSupport.new
    @category_job = CategoryJob.new
    @category_skill = CategorySkill.new
    @category_interest = CategoryInterest.new
    @category_about_regions = CategoryAboutRegion.all
    @category_incubations = CategoryIncubation.all
    @category_immigration_supports = CategoryImmigrationSupport.all
    @category_jobs = CategoryJob.all
    @category_skills = CategorySkill.all
    @category_interests = CategoryInterest.all
    @check_flags_profile_category_about_region = false
    @check_flags_profile_category_incubation = false
    @check_flags_profile_category_immigration_support = false
    @check_flags_profile_category_job = false
    @check_flags_profile_category_skill = false
    @check_flags_profile_category_interest = false
  end
  
  def create
    @user_profile = UserProfile.new(user_profile_params)
    category_about_region_ids = params[:category_about_region_id]
    category_immigration_support_ids = params[:category_immigration_support_id]
    category_immigration_support_ids = params[:category_immigration_support_id]
    category_job_ids = params[:category_job_id]
    category_skill_ids = params[:category_skill_id]
    category_interest_ids = params[:category_interest_id]
  
    if @user_profile.save
     
       if category_about_region_ids.present?
        category_about_region_ids.each do |category_about_region_id|
         profile_category_about_region = @user_profile.profile_category_about_regions.build(category_about_region_id: category_about_region_id)
         profile_category_about_region.save
        end
       end  
       
      if category_immigration_support_ids.present?
        category_immigration_support_ids.each do |category_immigration_support_id|
         profile_category_immigration_support = @user_profile.profile_category_immigration_supports.build(category_immigration_support_id: category_immigration_support_id)
         profile_category_immigration_support.save
        end
      end  
      
      if category_immigration_support_ids.present?
        category_immigration_support_ids.each do |category_immigration_support_id|
         profile_category_immigration_support = @user_profile.profile_category_immigration_supports.build(category_immigration_support_id: category_immigration_support_id)
         profile_category_immigration_support.save
        end
      end  
      
      if category_job_ids.present?
        category_job_ids.each do |category_job_id|
          profile_category_job = @user_profile.profile_category_jobs.build(category_job_id: category_job_id)
          profile_category_job.save
        end 
      end  
      
      if category_skill_ids.present?
        category_skill_ids.each do |category_skill_id|
          profile_category_skill = @user_profile.profile_category_skills.build(category_skill_id: category_skill_id)
          profile_category_skill.save
        end
      end
      
      if category_interest_ids.present?
        category_interest_ids.each do |category_interest_id|
          profile_category_interest = @user_profile.profile_category_interests.build(category_interest_id: category_interest_id)
          profile_category_interest.save
        end
      end 
      
       redirect_to @user_profile, notice:"登録が完了しました"
    else
      render "new", notice:"登録に失敗しました"
    end
    
  end
  
  def edit
    @user_profile = UserProfile.find(params[:id])
    @category_about_regions = CategoryAboutRegion.all
    @category_incubations = CategoryIncubation.all
    @category_immigration_supports = CategoryImmigrationSupport.all
    @category_jobs = CategoryJob.all
    @category_skills = CategorySkill.all
    @category_interests = CategoryInterest.all
    
    @check_flags_profile_category_about_region = []
    @category_about_regions.each_with_index do |category_about_region, index|
      pca = ProfileCategoryAboutRegion.where(category_about_region_id: category_about_region.id).where(user_profile_id: @user_profile.id)
      if pca.empty?
        @check_flags_profile_category_about_region[index] = false
      else
        @check_flags_profile_category_about_region[index] = true
      end
    end
    
    @check_flags_profile_category_immigration_support = []
    @category_immigration_supports.each_with_index do |category_immigration_support, index|
      pci = ProfileCategoryImmigrationSupport.where(category_immigration_support_id: category_immigration_support.id).where(user_profile_id: @user_profile.id)
      if pci.empty?
        @check_flags_profile_category_immigration_support[index] = false
      else
        @check_flags_profile_category_immigration_support[index] = true
      end
    end
    
    @check_flags_profile_category_incubation = []
    @category_incubations.each_with_index do |category_incubation, index|
      pci = ProfileCategoryIncubation.where(category_incubation_id: category_incubation.id).where(user_profile_id: @user_profile.id)
      if pci.empty?
        @check_flags_profile_category_incubation[index] = false
      else
        @check_flags_profile_category_incubation[index] = true
      end
    end
    
    @check_flags_profile_category_job = []
    @category_jobs.each_with_index do |category_job, index|
      pci = ProfileCategoryJob.where(category_job_id: category_job.id).where(user_profile_id: @user_profile.id)
      if pci.empty?
        @check_flags_profile_category_job[index] = false
      else
        @check_flags_profile_category_job[index] = true
      end
    end
    
    @check_flags_profile_category_skill = []
    @category_skills.each_with_index do |category_skill, index|
      pci = ProfileCategorySkill.where(category_skill_id: category_skill.id).where(user_profile_id: @user_profile.id)
      if pci.empty?
        @check_flags_profile_category_skill[index] = false
      else
        @check_flags_profile_category_skill[index] = true
      end
    end
    
    @check_flags_profile_category_interest = []
    @category_interests.each_with_index do |category_interest, index|
      pci = ProfileCategoryInterest.where(category_interest_id: category_interest.id).where(user_profile_id: @user_profile.id)
      if pci.empty?
        @check_flags_profile_category_interest[index] = false
      else
        @check_flags_profile_category_interest[index] = true
      end
    end 
  end
  
  def update
    @user_profile = UserProfile.find(params[:id])
    
    if @user_profile.update(user_profile_params)
      
      @profile_category_about_regions = @user_profile.profile_category_about_regions
      @profile_category_about_regions.each do |profile_category_about_region|
        profile_category_about_region.destroy
      end
      category_about_region_ids = params[:category_about_region_id]
      if category_about_region_ids.present?
        category_about_region_ids.each do |category_about_region_id|
         profile_category_about_region = @user_profile.profile_category_about_regions.build(category_about_region_id: category_about_region_id)
         profile_category_about_region.save
        end
      end 
      
      @profile_category_immigration_supports = @user_profile.profile_category_immigration_supports
      @profile_category_immigration_supports.each do |profile_category_immigration_support|
        profile_category_immigration_support.destroy
      end
      category_immigration_support_ids = params[:category_immigration_support_id]
      if category_immigration_support_ids.present?
        category_immigration_support_ids.each do |category_immigration_support_id|
         profile_category_immigration_support = @user_profile.profile_category_immigration_supports.build(category_immigration_support_id: category_immigration_support_id)
         profile_category_immigration_support.save
        end
      end   
      
      @profile_category_incubations = @user_profile.profile_category_incubations
      @profile_category_incubations.each do |profile_category_incubation|
        profile_category_incubation.destroy
      end
      category_incubation_ids = params[:category_incubation_id]
      if category_incubation_ids.present?
        category_incubation_ids.each do |category_incubation_id|
         profile_category_incubation = @user_profile.profile_category_incubations.build(category_incubation_id: category_incubation_id)
         profile_category_incubation.save
        end
      end
      
      @profile_category_jobs = @user_profile.profile_category_jobs
      @profile_category_jobs.each do |profile_category_job|
        profile_category_job.destroy
      end
      category_job_ids = params[:category_job_id]
      if category_job_ids.present?
        category_job_ids.each do |category_job_id|
         profile_category_job = @user_profile.profile_category_jobs.build(category_job_id: category_job_id)
         profile_category_job.save
        end
      end
      
      @profile_category_skills = @user_profile.profile_category_skills
      @profile_category_skills.each do |profile_category_skill|
        profile_category_skill.destroy
      end
      category_skill_ids = params[:category_skill_id]
      if category_skill_ids.present?
        category_skill_ids.each do |category_skill_id|
         profile_category_skill = @user_profile.profile_category_skills.build(category_skill_id: category_skill_id)
         profile_category_skill.save
        end
      end
      
      @profile_category_interests = @user_profile.profile_category_interests
      @profile_category_interests.each do |profile_category_interest|
        profile_category_interest.destroy
      end
      category_interest_ids = params[:category_interest_id]
      if category_interest_ids.present?
        category_interest_ids.each do |category_interest_id|
         profile_category_interest = @user_profile.profile_category_interests.build(category_interest_id: category_interest_id)
         profile_category_interest.save
        end
      end
   
   
      
      
      redirect_to @user_profile, notice:"更新しました"
    else
      render "edit"
    end
  end
  
  def show
    @user_profile = UserProfile.find(params[:id])
    @posts = @user_profile.user.posts
    @category_resources = CategoryResource.all
    # @profile_type1_flag = true
    # @profile_type2_flag = true
  end
  
  def index
    @user_profiles = UserProfile.all
    @profile_type1_flag = true
    @profile_type2_flag = true
    # @profile_type1_flag = current_user.user_profile.profile_type1
    # @profile_type2_flag = current_user.user_profile.profile_type2
    
    # if @post.post_type == 1
    # @profile_type1_flag = true
    # end
    
    # if @post.post_type == 2
    # @profile_type2_flag = true
    # end
  end
  
  private
  def user_profile_params
    params.require(:user_profile).permit(:user_id, :profile_type1, :profile_type2, :screen_name, :avatar, :prefecture, :city, :about_region, :immigration_support,:immigration_support,:job, :skill, :interest,:other1, :other2, :public_status_id)
  end
  
  def ensure_user
    @user_profile = UserProfile.find(params[:id])
    unless @user_profile.user_id == current_user.id
      redirect_to action: :show, id: @user_profile.id
    end
  end
end

class PostsBusinessController < ApplicationController
  
  before_action :authenticate_user!, except:[:index]
  before_action :user_profile_nil?
  
   def new
    @post = Post.new
    @category_earnests = CategoryEarnest.all
    @category_wants = CategoryWant.all
    @user_profile = current_user.user_profile
    @post_type_flag = 2
    @profile_type2_flag = true
    # @profile_type2_flag = false
   end
  
  def create
    @post = Post.new(post_params)
    @user_profile = current_user.user_profile
    
    category_wants_ids = params[:category_want_id]
    category_earnest_ids = params[:category_earnest_id]
    
    if @post.save
     if category_wants_ids.present?
       category_wants_ids.each do |category_wants_id|
        category_wants = @post.post_category_wants.build(category_want_id: category_wants_id)
        category_wants.save
       end
     end   
     if category_earnest_ids.present?
      category_earnest_ids.each do |category_earnest_id|
        category_earnest = @post.post_category_earnest.build(category_earnest_id: category_earnest_id)
        category_earnest.save
      end
     end  
     
      redirect_to @post, action: :show, id: @post.id, notice:"登録が完了しました"
    else
      render "new", notice:"登録に失敗しました"  
      #空欄以外で登録失敗ってある？空欄だと画面が遷移しない。
    end
  end
  
  def index
    @category_wants = CategoryWant.all
    @category_earnests = CategoryEarnest.all
    @category_jobs = CategoryJob.all
    @category_skills = CategorySkill.all
    @category_interests = CategoryInterest.all
    @post_type = params[:post_type]
    @prefecture = params[:prefecture]
    @keyword = params[:keyword]
    category_want_ids = params[:category_want_id]
    category_earnest_ids = params[:category_earnest_id]
    category_job_ids = params[:category_job_id]
    category_skill_ids = params[:category_skill_id]
    category_interest_ids = params[:category_interest_id]
    @search_type = params[:search_type]
    @posts = []
    @post_type_ids = []
    @posts_post_type_ids = []
    @posts_post_type_keyword = []
    @posts_post_type_prefecture = []
    @posts_post_type_prefecture_ids = []
    @posts_post_type_keyword_prefecture = []
    @posts_post_type_keyword_prefecture_ids = []
    @category_want_posts_all = []
    @category_earnest_posts_all = []
    @profile_category_jobs_all = []
    @profile_category_skills_all = []
    @profile_category_interests_all = []
    @posts_tag = []
    @post_tag_ids = []
    @profiles_tag = []
    @profile_tag_ids = []
    @post_profile_tag_ids = []
    @check_flags_category_wants = []
    @check_flags_category_earnests = []
    @check_flags_category_jobs = []
    @check_flags_category_skills = []
    @check_flags_category_interests = []
    
    #「起業希望者投稿」のみ抽出
    @posts_post_type = Post.where(post_type: 2)
    @posts_post_type_ids = @posts_post_type.pluck(:id)
    
    #キーワードが入力された場合　
    if @keyword.present?
     keyword = '%' + @keyword + '%'
     @posts_post_type_keyword = Post.where("title like ?", keyword).or(Post.where("body1 like ?", keyword)).where(id: @posts_post_type_ids)
    else
     @posts_post_type_keyword = @posts_post_type
    end 
      
    #「都道府県」が選択された場合
    if @prefecture.present?
      @post_prefecture = Post.where(prefecture: @prefecture)
      @posts_post_type_keyword_prefecture = @posts_post_type_keyword & @post_prefecture 
    else
      @posts_post_type_keyword_prefecture = @posts_post_type_keyword
    end 
    
    #「投稿タイプ」と「キーワード」と「都道府県」の条件を満たす投稿のid
    @posts_post_type_keyword_prefecture_ids = @posts_post_type_keyword_prefecture.pluck(:id)
    
    #　タグ「やりたいこと」「本気度」「職業」「得意なこと」「興味のあること」の各項目についてOR検索
    if @search_type == "1"   
      #　タグ「やりたいこと」「本気度」「職業」「得意なこと」「興味のあること」が一つも選択されていない場合
      if category_want_ids.nil? && category_earnest_ids.nil? && category_job_ids.nil? && category_skill_ids.nil? && category_interest_ids.nil?
        @posts = @posts_post_type_keyword_prefecture
      else
        #「やりたいこと」のチェックボックスが一つでもチェックされた場合
        if category_want_ids.present?
          category_want_ids.each do |category_want_id|  
            @post_category_wants = Post.joins(:post_category_wants).where(post_category_wants: {category_want_id: category_want_id})
            @post_category_wants.each do |post_category_want|
             @posts_tag = @posts_tag.append(post_category_want)
            end
          end
        end  
      
        #「本気度」のチェックボックスが一つでもチェックされた場合
        if category_earnest_ids.present?
          category_earnest_ids.each do |category_earnest_id|  
            @post_category_earnests = Post.joins(:post_category_earnest).where(post_category_earnests: {category_earnest_id: category_earnest_id})
            @post_category_earnests.each do |post_category_earnest|
              @posts_tag = @posts_tag.append(post_category_earnest)
            end
          end
        end 
        
        #プロフィールでの絞り込み
        if category_job_ids.nil? && category_skill_ids.nil? && category_interest_ids.nil?
         @posts_tag = @posts_tag
        else
         
         #「職業」のチェックボックスが一つでもチェックされた場合
         if category_job_ids.present?
          category_job_ids.each do |category_job_id|
           @profile_category_jobs = UserProfile.joins(:profile_category_jobs).where(profile_category_jobs: {category_job_id: category_job_id})
           @profile_category_jobs.each do |profile_category_job|
            @profiles_tag = @profiles_tag.append(profile_category_job)
           end 
          end 
         end
         
         #「得意なこと」のチェックボックスが一つでもチェックされた場合
         if category_skill_ids.present?
          category_skill_ids.each do |category_skill_id|
           @profile_category_skills = UserProfile.joins(:profile_category_skills).where(profile_category_skills: {category_skill_id: category_skill_id})
           @profile_category_skills.each do |profile_category_skill|
            @profiles_tag = @profiles_tag.append(profile_category_skill)
           end
          end 
         end
         
         #「興味のあること」のチェックボックスが一つでもチェックされた場合
         if category_interest_ids.present?
          category_interest_ids.each do |category_interest_id|
           @profile_category_interests = UserProfile.joins(:profile_category_interests).where(profile_category_interests: {category_interest_id: category_interest_id})
           @profile_category_interests.each do |profile_category_interest|
            @profiles_tag = @profiles_tag.append(profile_category_interest)
           end
          end 
         end
         
         @profile_tag_ids = @profiles_tag.pluck(:id)
         @posts_user = User.where(id: @profile_tag_ids)
         @posts_profile_tag = Post.where(user_id: @posts_user)
         @posts_profile_tag.each do |post_profile_tag|
         @posts_tag = @posts_tag.append(post_profile_tag)
         end
        end 
        @posts = @posts_tag & @posts_post_type_keyword_prefecture
      end
    
    #　タグ「やりたいこと」「本気度」「職業」「得意なこと」「興味のあること」の各項目についてAND検索
    elsif @search_type == "2"
      #　タグ「やりたいこと」「本気度」「職業」「得意なこと」「興味のあること」が一つも選択されていない場合
      if category_want_ids.nil? && category_earnest_ids.nil? && category_job_ids.nil? && category_skill_ids.nil? && category_interest_ids.nil?
        @posts = @posts_post_type_keyword_prefecture
      else
        #「やりたいこと」のチェックボックスが一つでもチェックされた場合
        if category_want_ids.present?
          category_want_ids.each do |category_want_id|  
            @category_want_posts = Post.joins(:post_category_wants).where(post_category_wants: {category_want_id: category_want_id})
            @category_want_posts.each do|category_want_post|
             @category_want_posts_all = @category_want_posts_all.append(category_want_post)
            end
             @category_want_posts_ids = @category_want_posts_all.pluck(:id).uniq
             @post_tag_ids = @category_want_posts_ids
          end
        end
        
        #「本気度」のチェックボックスが一つでもチェックされた場合
        if category_earnest_ids.present?
          category_earnest_ids.each do |category_earnest_id|  
            @category_earnest_posts = Post.joins(:post_category_earnest).where(post_category_earnests: {category_earnest_id: category_earnest_id})
            @category_earnest_posts.each do|category_earnest_post|
             @category_earnest_posts_all = @category_earnest_posts_all.append(category_earnest_post)
            end
             @category_earnest_posts_ids = @category_earnest_posts_all.pluck(:id).uniq
             if @post_tag_ids.empty?
              @post_tag_ids = @category_earnest_posts_ids
             else  
              @post_tag_ids = @post_tag_ids & @category_earnest_posts_ids
             end
          end   
        end
        
        #プロフィールでの絞り込み
        if category_job_ids.nil? && category_skill_ids.nil? && category_interest_ids.nil?
         @posts_tag_ids = @posts_tag_ids
        else
         
         #「職業」のチェックボックスが一つでもチェックされた場合
         if category_job_ids.present?
          category_job_ids.each do |category_job_id|
           @profile_category_jobs = UserProfile.joins(:profile_category_jobs).where(profile_category_jobs: {category_job_id: category_job_id})
           @profile_category_jobs.each do |profile_category_job|
            @profile_category_jobs_all = @profile_category_jobs_all.append(profile_category_job)
           end
          end
          @profiles_tag = @profile_category_jobs_all
          puts "ここだよ1"
          p @profile_category_jobs
          p @profiles_tag
         end
         
         #「得意なこと」のチェックボックスが一つでもチェックされた場合
         if category_skill_ids.present?
          category_skill_ids.each do |category_skill_id|
           @profile_category_skills = UserProfile.joins(:profile_category_skills).where(profile_category_skills: {category_skill_id: category_skill_id})
           @profile_category_skills.each do |profile_category_skill|
            @profile_category_skills_all = @profile_category_skills_all.append(profile_category_skill)
           end
          end
          if category_job_ids.nil?
           @profiles_tag = @profile_category_skills_all
          else
           @profiles_tag = @profiles_tag & @profile_category_skills_all
          end
          puts "ここだよ2"
          p @profile_category_skills_all
          p @profiles_tag
         end
         
         #「興味のあること」のチェックボックスが一つでもチェックされた場合
         if category_interest_ids.present?
          category_interest_ids.each do |category_interest_id|
           @profile_category_interests = UserProfile.joins(:profile_category_interests).where(profile_category_interests: {category_interest_id: category_interest_id})
           @profile_category_interests.each do |profile_category_interest|
            @profile_category_interests_all = @profile_category_interests_all.append(profile_category_interest)
           end
          end
          if category_job_ids.nil? &&  category_skill_ids.nil?
           @profiles_tag = @profile_category_interests_all
          else
           @profiles_tag = @profiles_tag & @profile_category_interests_all
          end
         end  
         
         @profile_tag_ids = @profiles_tag.pluck(:id)
         @posts_user = User.where(id: @profile_tag_ids)
         @posts_profile_tag = Post.where(user_id: @posts_user)
         @post_profile_tag_ids = @posts_profile_tag.pluck(:id)
         if @post_tag_ids.empty?
          @post_tag_ids = @post_profile_tag_ids
         else
          @post_tag_ids = @post_tag_ids & @post_profile_tag_ids
         end
        end 
        @posts_tag = Post.where(id: @post_tag_ids)
        @posts = @posts_tag & @posts_post_type_keyword_prefecture
      end
      
    #検索条件をクリアした場合  
    else
      @posts = Post.where(post_type: 2)
    end
    
 # チェック済のボックスにチェックを入れて検索結果を表示するため
   if category_want_ids.present?
    @category_wants.each_with_index do |category_want, index|
      if category_want_ids.include?(category_want.id.to_s)
       @check_flags_category_wants[index] = true
      else
       @check_flags_category_wants[index] = false
      end
    end
   end 
   
   if category_earnest_ids.present?
    @category_earnests.each_with_index do |category_earnest, index|
      if category_earnest_ids.include?(category_earnest.id.to_s)
       @check_flags_category_earnests[index] = true
      else
       @check_flags_category_earnests[index] = false
      end
    end
   end
   
   if category_job_ids.present?
    @category_jobs.each_with_index do |category_job, index|
      if category_job_ids.include?(category_job.id.to_s)
       @check_flags_category_jobs[index] = true
      else
       @check_flags_category_jobs[index] = false
      end
    end
   end
   
   if category_skill_ids.present?
     @category_skills.each_with_index do |category_skill, index|
      if category_skill_ids.include?(category_skill.id.to_s)
       @check_flags_category_skills[index] = true
      else
       @check_flags_category_skills[index] = false
      end
    end
   end
   
   if category_interest_ids.present?
     @category_interests.each_with_index do |category_interest, index|
      if category_interest_ids.include?(category_interest.id.to_s)
       @check_flags_category_interests[index] = true
      else
       @check_flags_category_interests[index] = false
      end
    end
   end
  end
  
  private
  def post_params
   params.require(:post).permit(:user_id, :post_type, :title, :prefecture, :city, :body1, :body2, :feature, :attachment, :realizability, :earnest, :public_status_id, images: [])
  end

  def ensure_user
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to action: "show", id: @post.id
    end
  end
  
  def user_profile_nil?
    if current_user.user_profile.nil?
     flash.now[:notice] = "先にプロフィール登録をお済ませください"
     render template: "user_profiles/new"
    end 
  end  
end

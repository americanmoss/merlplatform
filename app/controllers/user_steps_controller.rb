class UserStepsController < ApplicationController
 include Wicked::Wizard
 steps :mentor_signup, :entrepreneur_signup

 def show
  @user = current_user
  case step
   when :mentor_signup
    skip_step if @user.entrepreneur? 
   when :entrepreneur_signup
    skip_step unless @user.entrepreneur?
  end
  render_wizard
 end

 def update
  @user = current_user
  @user.attributes = user_params
  render_wizard @user
 end

 def finish_wizard_path
  current_user.user_status = 1
  current_user.save
  flash[:success] = "Signup complete."
  users_path
 end

 private

 def user_params
  params.require(:user).permit(:industry_id, skill_ids: [])
 end

end

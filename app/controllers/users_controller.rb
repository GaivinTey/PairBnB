class UsersController < ApplicationController

	def index
        @users = User.all
    end
    
    def show
        @user = User.find(params[:id])

    end

    def edit
        @user = User.find(params[:id])
    end

    def create
    end    

    def update
    	@user = User.find(params[:id])
    respond_to do |format|
     if @user.update(user_params)
  		format.html { redirect_to @user, notice: 'User was successfully updated.' }
     else
      format.html { render :edit }
      end
       end
    end



    def user_params
		  params.require(:user).permit(:email, :encrypted_password, :avatar)
	   end



end

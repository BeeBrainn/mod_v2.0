﻿class SpecsController < ApplicationController
  before_filter :authorize
  before_filter :admin_check, only: [:new, :update, :destroy]
  # GET /specs
  def index
    if @current_group && @current_group.admin_flag 
      @specs = Spec.all
    else
      @specs = Spec.where("user_id = ?", @current_user.id)
    end
    respond_to :html
  end

  # GET /users/1
  def show
    @spec = Spec.find(params[:id]) 
    respond_to :html
  end

  def new
    @spec = Spec.new
    @spec.user_id = params[:temp_user_id]
    @spec_user = User.find_by_id(params[:temp_user_id])
    if spec_nums = Spec.where("user_id = ?", @spec_user.id).order("created_at DESC")
      @spec.number = spec_nums.first.number + 1
    else
      @spec.number = 1
    end
    @spec.company_name = @spec_user.company_name
    @spec.unp_id = Unp.find_by_unp(@spec_user.unp).id
    @spec.date = Time.now.in_time_zone('Minsk').strftime("%d.%m.%Y")
    respond_to :html
  end

  def create
    @spec = Spec.new(params[:spec])
    respond_to do |format|
      if @spec.save
        format.html { redirect_to specs_path, notice: "Спецификация сохранена" }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @spec = Spec.find(params[:id])
    respond_to do |format|
      if @spec.update_attributes(params[:spec])
        format.html { redirect_to specs_path, notice: 'Спецификация успешно сохранена' }
      else
        format.html { render action: "update" }
      end
    end
  end

  def destroy
    @spec = Spec.find(params[:id])
    @spec.destroy

    respond_to do |format|
      format.html { redirect_to specs_url }
    end
  end
end

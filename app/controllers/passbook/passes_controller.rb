class Passbook::PassesController < ApplicationController
  respond_to :json

  def show
    @pass = Passbook::Pass.where(pass_type_identifier: params[:pass_type_identifier], serial_number: params[:serial_number]).first

    if @pass.nil?
      respond_with status: 404
    elsif stale?(last_modified: @pass.updated_at.utc)
      respond_with @pass 
    else
      respond_with status: 304 
    end    
  end
end

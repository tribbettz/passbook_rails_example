class Passbook::RegistrationsController < ApplicationController
  respond_to :json

  def index
    @pass = Passbook::Pass.where(pass_type_identifier: params[:pass_type_identifier]).first
    render nothing: true, status: 404 and return if @pass.nil?

    @registrations = @pass.registrations.where(device_library_identifier: params[:device_library_identifier])
    @registrations = @registrations.where("updated_at >= :passes_updated_since", {passes_updated_since: params[:passes_updated_since]}) if params[:passes_updated_since]

    if @registrations.any?
      respond_with({lastUpdated: @registrations.maximum(:updated_at), serialNumbers: @registrations.collect(&:pass).collect(&:serial_number)})
    else
      render nothing: true, status: 204
    end    
  end

  def create
    @pass = Passbook::Pass.where(pass_type_identifier: params[:pass_type_identifier], serial_number: params[:serial_number]).first
    render nothing: true, status: 404 and return if @pass.nil?

    @registration = @pass.registrations.first_or_initialize(device_library_identifier: params[:device_library_identifier])
    @registration.push_token = params[:push_token]

    status = @registration.new_record? ? 201 : 200

    @registration.save
      
    render nothing: true, status: status
  end

  def destroy
    @pass = Passbook::Pass.where(pass_type_identifier: params[:pass_type_identifier]).first
    render nothing: true, status: 404 and return if @pass.nil?

    @registration = @pass.registrations.where(device_library_identifier: params[:device_library_identifier]).first
    render nothing: true, status: 404 and return if @registration.nil?

    @registration.destroy

    render nothing: true, status: 200
  end
end

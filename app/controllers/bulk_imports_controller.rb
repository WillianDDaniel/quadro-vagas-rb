class BulkImportsController < ApplicationController
  before_action :check_user_is_admin

  def new
    @bulk_import = BulkImport.new
  end

  def create
    @bulk_import = BulkImport.new(bulk_import_params)

    if @bulk_import.save
      redirect_to @bulk_import, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bulk_import = BulkImport.find(params[:id])
  end

  def download_report
    bulk_import = BulkImport.find_by(id: params[:id])

    if bulk_import.nil?
      redirect_to root_path, alert: "Bulk import not found."
    end

    send_data bulk_import.generate_report, filename: "bulk_import_#{bulk_import.id}_report.txt", type: "text/plain"
  end

  private

  def bulk_import_params
    params.require(:bulk_import).permit(:file)
  end

  def check_user_is_admin
    unless Current.user.admin?
      redirect_to root_path
    end
  end
end

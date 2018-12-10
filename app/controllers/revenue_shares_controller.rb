class RevenueSharesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |_|
    head :not_found
  end

  before_action :authenticate_user!

  # GET /revenue_shares
  def index
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #index endpoint")
      return head :unauthorized
    end
    @revenue_shares = RevenueShare.all
    render :index
  end

  def prepare
    @latest_revenue_shares = current_user.revenue_shares.last(5)
    @new_revenue_share = current_user.revenue_shares.build
    render :prepare
  end

  def create
    @revenue_share = RevenueShare.new(revenue_share_params)
    redirect_to show_share_path, notice: 'Revenue share was successfully created.'
  end

  def update
    @revenue_share = RevenueShare.find_by!(id: params.permit(:id)[:id], user_id: current_user.id)
    return head :unauthorized unless @revenue_share.can_update?

    if @revenue_share.update(revenue_share_params)
      redirect_to prepare_revenue_shares_path, notice: 'Revenue share was successfully updated.'
    else
      render :prepare
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
  def revenue_share_params
    params.require(:revenue_share).permit(:amount, :share_due, :user_id)
  end
end

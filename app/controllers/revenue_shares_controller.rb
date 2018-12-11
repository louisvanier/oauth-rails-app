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
    @search_filters = {
      start_date: search_params[:q].try!(:[], :start_date) || Date.today,
      end_date: search_params[:q].try!(:[], :end_date) || Date.today,
      employee: search_params[:employee],
    }
    @revenue_shares = RevenueShare.where(search_filters_to_sql_filters(@search_filters))
      .includes(:user)
      .order(created_at: :desc)
      .map do |rec|
      {
        id: rec.id,
        amount: rec.amount,
        share_due: rec.share_due,
        created_at: rec.created_at,
        image_url: rec.user.image_url,
        name: rec.user.name,
      }
    end
    @users_for_select = User.all.select { |u| !current_tenant.is_admin?(u.email) }.map do |u|
      [u.name, u.id]
    end.insert(0, ['do not filter by user', -1])

    render :index
  end

  def prepare
    @latest_revenue_shares = current_user.revenue_shares.order(created_at: :desc).first(5)
    @new_revenue_share = current_user.revenue_shares.build
    render :prepare
  end

  def create
    current_user.revenue_shares.build.create(amount: revenue_share_params[:amount].to_f, share_percentage: current_user.share_percentage)
    redirect_to prepare_revenue_shares_path, notice: 'Revenue share was successfully created.'
  end

  def update
    @revenue_share = RevenueShare.find_by!(id: params.permit(:id)[:id], user_id: current_user.id)
    return head :unauthorized unless @revenue_share.can_update?

    if @revenue_share.update(revenue_share_params)
      redirect_to prepare_revenue_shares_path, notice: 'Revenue share was successfully updated.'
    else
      redirect_to prepare_revenue_shares_path, notice: 'Unable to update revenue share'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
  def revenue_share_params
    params.require(:revenue_share).permit(:amount)
  end

  def search_params
    params.permit(:employee, q: {})
  end

  def search_filters_to_sql_filters(filters)
    start_date = filters[:start_date].to_date
    end_date = filters[:end_date].to_date
    {
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      user_id: filters[:employee].to_i == -1 ? nil : filters[:employee]
    }.compact
  end
end

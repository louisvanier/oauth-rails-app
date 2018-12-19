class RevenueSharesController < ApplicationController
  include StrongerParameters::ControllerSupport::PermittedParameters

  rescue_from ActiveRecord::RecordNotFound do |_|
    head :not_found
  end

  before_action :authenticate_user!

  # GET /revenue_shares
  permitted_parameters :index, q: { start_date: Parameters.datetime, end_date: Parameters.datetime }, employee: Parameters.integer
  def index
    unless is_admin?
      Rails.logger.info("[UNAUTHORIZED] non-admin user hitting #index endpoint")
      return head :unauthorized
    end
    @search_filters = {
      start_date: params[:q].try!(:[], :start_date) || Date.today,
      end_date: params[:q].try!(:[], :end_date) || Date.today,
      employee: params[:employee],
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
  end

  permitted_parameters :prepare, {}
  def prepare
    @latest_revenue_shares = current_user.revenue_shares.order(created_at: :desc).first(5)
    @new_revenue_share = current_user.revenue_shares.build
  end

  permitted_parameters :mine, q: { start_date: Parameters.datetime, end_date: Parameters.datetime }
  def mine
    @search_filters = {
      start_date: params[:q].try!(:[], :start_date) || Date.today,
      end_date: params[:q].try!(:[], :end_date) || Date.today,
    }
    @my_revenue_shares = RevenueShare.where(user_id: current_user.id).where(search_filters_to_sql_filters(@search_filters))
  end

  permitted_parameters :create, revenue_share: { amount: Parameters.float | Parameters.integer }
  def create
    current_user.revenue_shares.build.create(amount: params[:revenue_share][:amount].to_f, share_percentage: current_user.share_percentage)
    redirect_to prepare_revenue_shares_path, notice: 'Revenue share was successfully created.'
  end

  permitted_parameters :update, id: Parameters.id, revenue_share: { amount: Parameters.float | Parameters.integer }
  def update
    @revenue_share = RevenueShare.find_by!(id: params[:id], user_id: current_user.id)
    return head :unauthorized unless @revenue_share.can_update?

    if @revenue_share.create(amount: params[:revenue_share][:amount], share_percentage: current_user.share_percentage)
      redirect_to prepare_revenue_shares_path, notice: 'Revenue share was successfully updated.'
    else
      redirect_to prepare_revenue_shares_path, notice: 'Unable to update revenue share'
    end
  end

  private

  def search_filters_to_sql_filters(filters)
    start_date = filters[:start_date].to_date
    end_date = filters[:end_date].to_date
    {
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      user_id: filters[:employee]&.to_i == -1 ? nil : filters[:employee]
    }.compact
  end
end

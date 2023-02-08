class Account::StrengthsController < Account::ApplicationController
  account_load_and_authorize_resource :strength, through: :feature, through_association: :strengths

  # GET /account/features/:feature_id/strengths
  # GET /account/features/:feature_id/strengths.json
  def index
    delegate_json_to_api
  end

  # GET /account/strengths/:id
  # GET /account/strengths/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/features/:feature_id/strengths/new
  def new
  end

  # GET /account/strengths/:id/edit
  def edit
  end

  # POST /account/features/:feature_id/strengths
  # POST /account/features/:feature_id/strengths.json
  def create
    respond_to do |format|
      if @strength.save
        format.html { redirect_to [:account, @feature, :strengths], notice: I18n.t("strengths.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @strength] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strength.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/strengths/:id
  # PATCH/PUT /account/strengths/:id.json
  def update
    respond_to do |format|
      if @strength.update(strength_params)
        format.html { redirect_to [:account, @strength], notice: I18n.t("strengths.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @strength] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strength.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/strengths/:id
  # DELETE /account/strengths/:id.json
  def destroy
    @strength.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @feature, :strengths], notice: I18n.t("strengths.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end

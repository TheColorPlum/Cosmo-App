class Account::WeaknessesController < Account::ApplicationController
  account_load_and_authorize_resource :weakness, through: :feature, through_association: :weaknesses

  # GET /account/features/:feature_id/weaknesses
  # GET /account/features/:feature_id/weaknesses.json
  def index
    delegate_json_to_api
  end

  # GET /account/weaknesses/:id
  # GET /account/weaknesses/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/features/:feature_id/weaknesses/new
  def new
  end

  # GET /account/weaknesses/:id/edit
  def edit
  end

  # POST /account/features/:feature_id/weaknesses
  # POST /account/features/:feature_id/weaknesses.json
  def create
    respond_to do |format|
      if @weakness.save
        format.html { redirect_to [:account, @feature, :weaknesses], notice: I18n.t("weaknesses.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @weakness] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @weakness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/weaknesses/:id
  # PATCH/PUT /account/weaknesses/:id.json
  def update
    respond_to do |format|
      if @weakness.update(weakness_params)
        format.html { redirect_to [:account, @weakness], notice: I18n.t("weaknesses.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @weakness] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @weakness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/weaknesses/:id
  # DELETE /account/weaknesses/:id.json
  def destroy
    @weakness.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @feature, :weaknesses], notice: I18n.t("weaknesses.notifications.destroyed") }
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

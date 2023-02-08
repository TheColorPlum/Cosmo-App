class Account::FeaturesController < Account::ApplicationController
  account_load_and_authorize_resource :feature, through: :product, through_association: :features

  # GET /account/products/:product_id/features
  # GET /account/products/:product_id/features.json
  def index
    delegate_json_to_api
  end

  # GET /account/features/:id
  # GET /account/features/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/products/:product_id/features/new
  def new
  end

  # GET /account/features/:id/edit
  def edit
  end

  # POST /account/products/:product_id/features
  # POST /account/products/:product_id/features.json
  def create
    respond_to do |format|
      if @feature.save
        format.html { redirect_to [:account, @product, :features], notice: I18n.t("features.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @feature] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/features/:id
  # PATCH/PUT /account/features/:id.json
  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to [:account, @feature], notice: I18n.t("features.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @feature] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/features/:id
  # DELETE /account/features/:id.json
  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @product, :features], notice: I18n.t("features.notifications.destroyed") }
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

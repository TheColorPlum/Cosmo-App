class Account::ProductsController < Account::ApplicationController
  account_load_and_authorize_resource :product, through: :team, through_association: :products

  # GET /account/teams/:team_id/products
  # GET /account/teams/:team_id/products.json
  def index
    delegate_json_to_api
  end

  # GET /account/products/:id
  # GET /account/products/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/products/new
  def new
  end

  # GET /account/products/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/products
  # POST /account/teams/:team_id/products.json
  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to [:account, @team, :products], notice: I18n.t("products.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @product] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/products/:id
  # PATCH/PUT /account/products/:id.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:account, @product], notice: I18n.t("products.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @product] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/products/:id
  # DELETE /account/products/:id.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :products], notice: I18n.t("products.notifications.destroyed") }
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

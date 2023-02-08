class Account::ContentHubsController < Account::ApplicationController
  account_load_and_authorize_resource :content_hub, through: :team, through_association: :content_hubs

  # GET /account/teams/:team_id/content_hubs
  # GET /account/teams/:team_id/content_hubs.json
  def index
    delegate_json_to_api
  end

  # GET /account/content_hubs/:id
  # GET /account/content_hubs/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/content_hubs/new
  def new
  end

  # GET /account/content_hubs/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/content_hubs
  # POST /account/teams/:team_id/content_hubs.json
  def create
    respond_to do |format|
      if @content_hub.save
        format.html { redirect_to [:account, @team, :content_hubs], notice: I18n.t("content_hubs.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @content_hub] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @content_hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/content_hubs/:id
  # PATCH/PUT /account/content_hubs/:id.json
  def update
    respond_to do |format|
      if @content_hub.update(content_hub_params)
        format.html { redirect_to [:account, @content_hub], notice: I18n.t("content_hubs.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @content_hub] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @content_hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/content_hubs/:id
  # DELETE /account/content_hubs/:id.json
  def destroy
    @content_hub.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :content_hubs], notice: I18n.t("content_hubs.notifications.destroyed") }
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

class Account::ContentsController < Account::ApplicationController
  account_load_and_authorize_resource :content, through: :team, through_association: :contents

  # GET /account/teams/:team_id/contents
  # GET /account/teams/:team_id/contents.json
  def index
    delegate_json_to_api
  end

  # GET /account/contents/:id
  # GET /account/contents/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/contents/new
  def new
  end

  # GET /account/contents/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/contents
  # POST /account/teams/:team_id/contents.json
  def create
    respond_to do |format|
      if @content.save
        format.html { redirect_to [:account, @team, :contents], notice: I18n.t("contents.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @content] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/contents/:id
  # PATCH/PUT /account/contents/:id.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to [:account, @content], notice: I18n.t("contents.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @content] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/contents/:id
  # DELETE /account/contents/:id.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :contents], notice: I18n.t("contents.notifications.destroyed") }
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

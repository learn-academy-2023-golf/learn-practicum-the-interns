class Account::NotesController < Account::ApplicationController
  account_load_and_authorize_resource :note, through: :team, through_association: :notes

  # GET /account/teams/:team_id/notes
  # GET /account/teams/:team_id/notes.json
  def index
    delegate_json_to_api
  end

  # GET /account/notes/:id
  # GET /account/notes/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/notes/new
  def new
  end

  # GET /account/notes/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/notes
  # POST /account/teams/:team_id/notes.json
  def create
    respond_to do |format|
      if @note.save
        format.html { redirect_to [:account, @note], notice: I18n.t("notes.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @note] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/notes/:id
  # PATCH/PUT /account/notes/:id.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to [:account, @note], notice: I18n.t("notes.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @note] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/notes/:id
  # DELETE /account/notes/:id.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :notes], notice: I18n.t("notes.notifications.destroyed") }
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

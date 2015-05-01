class ReportsController < ApplicationController
  before_action :set_report, :set_attachment, only: [:show, :edit, :update, :destroy, :progress, :download]
	before_action :authenticate_user!, only: [:new, :edit, :index, :show, :destroy]

  def download
    send_data @attachment.file, filename: @attachment.name
  end

  # GET /reports
  # GET /reports.json
  def index
    # 検索条件の指定がないときは、デフォルトで7日前からの検索にする
    # index.html.erbの初期値との整合性に注意
    if params[:q].nil?
      params[:q] = {
        updated_at_gteq: 7.day.ago.strftime('%Y-%m-%d'),
        updated_at_lteq_end_of_day: 0.day.ago.strftime('%Y-%m-%d')
      }
    end

    @base = Report.with_progress_points
    # ransakで検索
    # https://github.com/activerecord-hackery/ransack
    @q = @base.ransack(params[:q])
    # left joinしたprogress_pointsはransakでは直接扱えないため、個別対応
    if params[:q][:s].nil? || !params[:q][:s].include?('progress_points')
      @reports = @q.result.index_default_order
    else
      @reports = @q.result.order(params[:q][:s])
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    respond_to do |format|
      begin
        Report.transaction do
          @report = Report.new(report_params)
          report = @report.save!
          update_or_create_attachment!(attachment_params)
        end
        format.html { redirect_to action: 'index', notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      rescue
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      begin
        Report.transaction do
          @report.update!(report_params)
          @report.touch
          update_or_create_attachment!(attachment_params)
        end
        format.html { redirect_to action: 'index', notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      rescue
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    def set_attachment
      # TODO: 複数ファイル対応
      @attachment = Attachment.find_by(report_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :tag, :content, :user_id, :created_at, :updated_at)
    end

    def attachment_params
      params.require(:report).permit(:id, :attachment)
      file = params[:report][:attachment]
      attachment = {}
      unless file.nil?
        attachment[:file] = file.read
        attachment[:name] = file.original_filename
      end
      attachment[:report_id] = params[:id]
      attachment
    end

    def update_or_create_attachment!(data)
      # 検索した@attachmentが空でなければupdate
      unless @attachment.nil?
        @attachment.update!(data)
        @attachment.touch
      end
      # 検索した@attachementが空で、リクエストのattachmentが空でなければcreate
      unless params[:report][:attachment].nil?
        @attachment = Attachment.create!(data)
      end
    end
end

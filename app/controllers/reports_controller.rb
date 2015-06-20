class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :progress]
  before_action :set_user_with_progress_points, only: :index
  before_action :set_attachment, only: :download
  before_action :check_current_users_report, only: [:edit, :update, :destroy]

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

    @base = Report.page(params[:page]).with_progress_points_and_number_of_comments
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
          @report.save!
          create_attachments!(attachment_params(@report.id))
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
          create_attachments!(attachment_params(params[:id]))
        end
        format.html { redirect_to reports_url, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      rescue => e
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

  def tags
    @tags = Report.select(:tag).uniq
    render json: @tags
  end

  def tagcloud
  end
  def tagcount
    uniq_tags = Report.select(:tag).uniq.map{|v| v.tag}

    # 複数タグを半角スペース区切りで入力している場合があるのでそれを分離
    tags = Report.select(:tag).map{|v| v.tag}
    all_tags = []
    tags.each do |tag|
      all_tags.concat(tag.split(' '))
    end

    # uniq_tagsには半角スペース区切りのタグが含まれていて、それのカウントは0になるので、最後のselectでそれを除外
    render json: uniq_tags.map{ |tag| { text: tag, weight: all_tags.count(tag) } }.select { |v| v[:weight] > 0 }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    def set_user_with_progress_points
      @user_with_progress_points = Report.progress_points_by_user_this_month
    end

    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :tag, :content, :user_id, :created_at, :updated_at)
    end

    def attachment_params(report_id)
      params.require(:report).permit(:id, :attachments)
      
      attachments = []
      unless params[:report][:attachments].nil?
        params[:report][:attachments].each do |a|
          attachments.push( { file: a.read, name: a.original_filename, report_id: report_id } )
        end
      end
      attachments
    end

    def create_attachments!(data)
      # リクエストのattachmentsが空でなければcreate
      unless params[:report][:attachments].nil?
        data.each do |a|
          Attachment.create!(a)
        end
      end
    end

    def check_current_users_report
      puts @report.user_id
      redirect_to(root_path) unless current_user.id == @report.user_id
    end

end

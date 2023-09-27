class Admin::EntryLogsController < ApplicationController
  
  def index
    @reservations = Reservation.all
    @entry_logs = EntryLog.all
  end
  
  def new
    @entry_log = EntryLog.new
  end

  
  def create
    barcode_number = params[:entry_log][:barcode] 
    user = ::User.find_by(barcode_number: barcode_number.strip)

    if user
      # 同じ日のエントリーログが存在するかを確認
      existing_entry_log = EntryLog.where("DATE(entry_time) = ? AND user_id = ?", Date.today, user.id).first
  
      if existing_entry_log
        flash[:alert] = "今日はすでに入室しています。"
        redirect_to new_admin_entry_log_path
        return
      end
      
      entry_log = EntryLog.new(user_id: user.id, entry_time: Time.now)

      if entry_log.save
        flash[:notice] = "エントリーログが正常に作成されました。"
        redirect_to new_admin_entry_log_path, notice: 'エントリーログが作成されました'
      else
        flash[:alert] = "エントリーログの作成に失敗しました。"
        redirect_to new_admin_entry_log_path  # 例：エントリーログ作成ページへ戻る
      end

    else
      flash[:alert] = "該当するバーコードのユーザーが見つかりません。"
      redirect_to new_admin_entry_log_path  # 例：エントリーログ作成ページへ戻る
    end
  end
  
  
  def exit
    @entry_log = EntryLog.new
  end
  
  def update_exit_time
    # パラメータからバーコードを取得
    barcode_number = params[:entry_log][:barcode].strip
  
    # バーコードに対応するユーザーを見つける
    user = User.find_by(barcode_number: barcode_number)
  
    if user
      # 最新の未出退室のentry_logを取得
      entry_log = EntryLog.where(user_id: user.id).where(exit_time: nil).order("entry_time DESC").first
  
      if entry_log
        # exit_timeを現在時刻に更新
        entry_log.update(exit_time: Time.current)
    
        # 成功メッセージとともに何らかのページにリダイレクト
        redirect_to exit_admin_entry_logs_path, notice: "退室時間が記録されました"
      else
        # エラーメッセージを表示
        flash[:alert] = "最新の入室記録が見つかりません"
        render :exit
      end
    else
      # エラーメッセージを表示
      flash[:alert] = "該当するバーコードが見つかりません"
      render :exit
    end
  end
  

  private

  def entry_log_params
    params.require(:entry_log).permit(:barcode)
  end
end

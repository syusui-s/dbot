#-*- encoding:utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "dbot"))
require File.expand_path(File.join(File.dirname(__FILE__), "generator"))

Plugin.create(:dbot) do
  # 初回起動時設定
  UserConfig[:dbot_bool] ||= false
  UserConfig[:dbot_dbfile] ||= ""
  UserConfig[:dbot_timewait] ||= 20
  UserConfig[:dbot_footer] ||= ""

  # 設定画面
  settings "dbotの設定"  do 
    boolean "定期投稿", :dbot_bool
    fileselect "DBファイル", :dbot_dbfile, "~/" 

    settings "投稿設定" do
      adjustment '投稿間隔（分）', :dbot_timewait, 1, 60*24
      input "bot用フッター", :dbot_footer
      select '生成方法', :dbot_gentype do
        option :random, "[ランダムに生成]"
        SentenceGenerator.gen_methods.each{|t|
          option t, t.to_s
        } end
    end
  end

  # mikutter_botにつぶやかせる
  def syspost(str)
    activity(:system,"dbot::#{str}") end

  # 残り時間をmikutter_botがつぶやきます
  def syspost_remain(remain)
    hour=(remain/3600).to_i
    min=((remain%3600)/60).to_i
    sec=((remain)%60).to_i

    syspost "Notice:だいたい、あと#{(hour==0)?"":(hour.to_s+"時間")}#{(min==0 && hour==0)?"":(min.to_s+"分")}#{sec}秒でつぶやきます。"
  end

  # Errorをmikutter_botにつぶやかせる
  def syspost_err(str)
    syspost "Error:#{str}" end

  # :dbot_gentypeに指定された方法で、botがつぶやく
  def post
    Thread.new{
      dbfile = UserConfig[:dbot_dbfile]
      if File.exist?(dbfile) and File.read(dbfile)[0..5] == "SQLite" then
        # 文章生成オブジェクトの作成
        db=WordsDB.new(dbfile)
        gen=SentenceGenerator.new(db)

        # 投稿処理
        tweet=gen.exec(UserConfig[:dbot_gentype])
        Service.primary.update(:message => "#{tweet} #{UserConfig[:dbot_footer]}")

        # 最終処理
        UserConfig[:dbot_lasttwit] = Time.now.to_i
        db.close
      else
        syspost_err "MySQL3のDBが見つからないか、指定されたファイルがDBではありません。設定を見なおしてください。投稿を中止します。"
      end
    }
  end

  # 自動返信機能（未実装）
  #def reply
  #end

  # データ収集機能（未実装）

  # 起動時に、:dbot_lasttwitに現在時刻(UNIXTIME)を入れておく
  on_boot do |service|
    UserConfig[:dbot_lasttwit] = Time.now.to_i
  end

  # 一分ごとに確認
  on_period do |service|
    if(UserConfig[:dbot_bool]) then
      # 残り時間（秒数）の計算
      remain=(UserConfig[:dbot_lasttwit]+UserConfig[:dbot_timewait]*60)-Time.now.to_i

      if(remain<=60) then
        syspost_remain(remain)
        Reserver.new((remain >= 0) ? remain : 0){post}
      else syspost_remain(remain) end
    end
  end
end


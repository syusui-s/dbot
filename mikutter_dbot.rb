#-*- encoding:utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "dbot"))
require File.expand_path(File.join(File.dirname(__FILE__), "generator"))

Plugin.create(:dbot) do
  # 初回起動時設定
  UserConfig[:dbot_bool] ||= false
  UserConfig[:dbot_dbfile] ||= ""
  UserConfig[:dbot_timewait] ||= 5
  UserConfig[:dbot_footer] ||= ""

  # 設定画面
  settings "dbotの設定"  do 
    boolean "dbotを作動", :dbot_bool
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
  
  def post
    Thread.new{
      dbfile = UserConfig[:dbot_dbfile]
      if File.exist?(dbfile) and File.read(dbfile)[0..5] == "SQLite" then
        db=WordsDB.new(dbfile)
      else
        syspost "Error:MySQL3のDBが見つからないか、指定されたファイルがDBではありません。設定を見なおしてください。投稿を中止します。"
        db=nil
      end

      if not db.nil? and UserConfig[:dbot_bool] then
        gen=SentenceGenerator.new(db)
        tweet=gen.exec(UserConfig[:dbot_gentype])
        Service.primary.update(:message => "#{tweet} #{UserConfig[:dbot_footer]}")
        UserConfig[:dbot_lasttwit] = Time.now.to_i
      end
    }
  end

  # 動作
  on_boot do |service|
    UserConfig[:dbot_lasttwit] = Time.now.to_i
  end

  on_period do |service|
    # 残り時間の計算
    remain=(UserConfig[:dbot_lasttwit]+UserConfig[:dbot_timewait]*60)-Time.now.to_i
    hour=(remain/3600).to_i
    min=((remain%3600)/60).to_i
    sec=((remain)%60).to_i

    if(remain<=0)
      post
    else 
      syspost "Notice:あと#{(hour==0)?"":(hour.to_s+"時間")}#{(min==0 && hour==0)?"":(min.to_s+"分")}#{sec}秒±60秒以内につぶやきます。"
    end
  end
end


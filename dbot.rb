#-*- encoding: utf-8 -*-
require 'sqlite3'
require 'kconv'
require 'MeCab'

# dbotは、MeCabのデフォルトの辞書を利用します。
# 他の辞書が使いたいときは、MECAB_DICDIRにディレクトリのパスを文字列型（String）で指定してください。
# 例:
# MECAB_DICDIR = File.expand_path(File.join(File.dirname(__FILE__), "unidic-mecab-2.1.2_src/unidic/"))

MecabParse =  MeCab::Tagger.new (defined?(MECAB_DICDIR) ? "-d #{MECAB_DICDIR}" : "")

=begin
テーブルの一覧
---------------
# テーブル1 単語リスト
|ID    |POS |word |times|
|識別子|品詞|単語 |回数 |
 1,副詞,とにかく,1
 2,動詞,やる,1
 3,助詞,っきゃ,1
 4,形容詞,ない,1

# テーブル2 サクセサーリスト
|ID    |SUCC        |
|識別子|次単語識別子|
 1,0
 2,1
=end

# データベースを取り扱うクラス
class WordsDB
  # コンストラクタ(DBの作成)
  def initialize(filename = 'wordsdata.db')
    @db = SQLite3::Database.new(filename)
  end

  # DBの初期化（テーブルの作成）
  def initdb()
    sql1 = <<-SQL
    create table words(
      id     integer primary key autoincrement,
      word   text,
      pos    text
    );
    SQL
    sql2 = <<-SQL
    create table succlist(
      id     integer,
      succ   integer,
      times  integer
    );
    SQL
    @db.execute(sql1)
    @db.execute(sql2)
    @db.execute("insert into words values(0,'','')")
  end
  
  # DBのクローズ
  def close()
    if not @db.closed? then
      @db.close()
      true
    else false end
  end

  #############################################################################
  # Match Selector
  #  DBから条件にあうものを検索し、それらを配列として返す

  # 単語(word)から検索
  def match_word(word)
    if not word.empty? then
      @db.execute("select * from words where word = ?",word)
    else [] end
  end

  # 品詞(pos)から検索
  def match_pos(pos)
    if not pos.empty? then
      @db.execute("select * from wors where pos = ?",pos)
    else [] end
  end

  # 固有値(id)から検索
  def match_id(id)
    if id.kind_of?(Integer)
      @db.execute("select * from words where id = ?",id)
    else [] end
  end

  # 単語と品詞から検索
  def match_word_pos(word,pos)
    if word.kind_of?(String) and pos.kind_of?(String) then
      return [] if word.empty? and pos.empty?
      @db.execute("select * from words where word = ? and pos = ?",word,pos)
    else [] end
  end

  # idとsuccにマッチするのを探す
  def match_succlist_id_succ(id,succ)
    if id.kind_of?(Integer) and succ.kind_of?(Integer) then
      @db.execute("select * from succlist where id = ? and succ = ?",id,succ)
    else [] end
  end

  #############################################################################
  # Random Selector
  #  DBから条件にあうものをランダムに選択し、それを配列として返す

  # idにマッチするものをsucclistから探す
  def random_succ_match_id(id)
    if id.kind_of?(Integer) then 
      @db.execute("select * from succlist where id = ? order by random() limit 1;",id)
    else []
    end
  end

  # posにマッチするものをsucclistから探す
  def random_match_pos(pos)
    if pos.kind_of?(String) then
      @db.execute("select * from words where pos = ? order by random() limit 1;",pos)
     else []
    end
  end

  # 新しく文章を追加
  def insert_str(string)
    arr=LangParse::parse(string)
    if arr.empty? then
      return []
    end
    # テーブルwordsに追加すると共に、それぞれのidを取得し、配列にして返す
    arr.map!{|word, pos|
      data = match_word_pos(word,pos)
      if data.empty?
        @db.execute("insert into words values(NULL,?,?)",word,pos) 
        id=@db.execute("select * from sqlite_sequence")[0][1]
      else
        id=data[0][0]
      end
      [id,word,pos] # 返値フォーマット
    }

    # テーブルsucclistに追加する部分
    for i in -1..(arr.length-1)
      id = (i == -1) ? 0 : arr[i][0]
      succ = (i+1) < arr.length ? arr[i+1][0] : 0
      data=match_id_succ(id,succ)
      
      # 見つからないなら、新しく追加
      if data.empty? then
        @db.execute("insert into succlist values(?,?,1)",id,succ)
      # 見つかっていれば、回数を増やす
      else
        times=data[0][2]+1
        @db.execute("update succlist set times = ? where id = ? and succ = ?",times,id,succ)
      end
    end
  end

end

# 文をパースするモジュール。他の形態素解析ソフトウェアにも対応できるようにするためのモジュール化。
module LangParse
  def parse(input)
    m=MecabParse.parse(input).toutf8.split(/\n/).map{|t|t.split(/,/)[0].split(/\t/)}
    m.pop;m
  end
  module_function :parse
end


#-*- encoding:utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "dbot"))

# 文生成用クラス
class SentenceGenerator
  # コンストラクタ。引数には、WordsDBのオブジェクトを指定する。
  # ==== Args
  # db :: WordsDBのオブジェクトを指定する。
  # ==== Return
  def initialize(db)
    @db = db
  end

  # 生成メソッドをランダムに選択し、それの実行結果を返す。
  def random()
    self.exec(self.gen_methods.shuffle[0]) end

  # 引数に指定されたメソッドを実行する
  # ==== Args
  # symbol :: メソッドのシンボル名。主に生成メソッドを指定する。
  # ==== Return
  def exec(symbol)
    self.__send__(symbol) end

  # 生成メソッドのリストを返す。シンボルで返す。
  def SentenceGenerator.gen_methods()
    instance_methods.grep(/gen\_/) end

  # 以下に文章生成メソッドを書いていく。
  # gen_から始まるメソッドでないと、gen_methodsから認識されない。
  # 認識させたい場合は、気をつけること。

  # -- gen_random -------------------
  # 乱数を使って適当に文章を生成するメソッド
  def gen_random()
    nxt=@db.random_succ_match_id(0)[0][1]
    data=@db.match_id(nxt)[0]
    result=data[1]
    while data[0] != 0 and data[1] != "。"
      nxt=@db.random_succ_match_id(nxt)[0][1]
      data=@db.match_id(nxt)[0]
      result+=data[1]
    end
    result
  end
end

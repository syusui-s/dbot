dbot : 適当に文章生成するbot
============================

## dbotとは
ツイートを単語や記号ごとに分解して、保存し、保存した単語から、変な文章を生成するちっちゃなソフトウェアです  
（形態素解析の結果から、形態素間のつながりを記録し、それを用いて文章を生成するソフトウェアです）。

mikutterで動くbot作りたかったので、作りました。  
そのうちちゃんとマルコフ連鎖とかするようにします。

## ファイルについて
* dbot.rb  
    メインのファイルです。DB生成とツイートの分析をここで行なっています。
* generator.rb  
    文章生成のファイルです。文章の生成をここで行います。
* import\_twilog.rb  
    TwilogからダウンロードできるCSVファイルを分析し、DBに保存します。
* mikutter\_dbot.rb  
    mikutter用プラグインです。

## インストール
お好きなフォルダで、`git clone`するだけです。

* 通常インストール  
  `$ git clone git@github.com:syusui-s/dbot.git`
* mikutterで使う場合  
  ` $ git clone git@github.com:syusui-s/dbot.git ~/.mikutter/plugin/mikutter_dbot`

## 使い方
ここでは、import\_twilog.rbを使ってDBを作り、そのDBを用いて文章生成する方法を書いておきます。

1. Twilogから過去のツイートのアーカイブ(UTF-8)をダウンロードし、展開する。  
  `$ gzip -d username_130522.csv.gz`  
2. import\_twilog.rb を用いて、DBを生成する。  
  この作業は時間がかかりますので、気長にお待ちください。  
  実行権限がない場合は、`$ chmod +x ./import_twilog.rb`して、実行できるようにしてください。  
  `$ ./import_twilog.rb username_130522.csv words.db`  
  メモリに余裕があれば、/dev/shm/ や RAMDISKにcsvと出力先を指定すると、とても早くなります。  
  例: `$ ./import_twilog.rb /dev/shm/username_130522.csv /dev/shm/words.db`  
  作業が終わったら、dbotのあるフォルダにでも移動してください。
3. Rubyのインタプリタを立ち上げる  
  Rubyのインタプリタ（irbやpry）を起動します。
4. 試しに文章を生成してみます  
  インタプリタで実行してみます。  
  ./test.dbには3で作ったDBファイルのパスを指定してください。 

	`
	require './generator'  
	gen=SentenceGenerator.new(WordsDB("./test.db"))  
	gen.random  
	`

  ちゃんと出力されれば成功です。おめでとうございます！  

## 生成方法の追加
generator.rbのSentenceGeneratorクラスに、「gen\_」から始まるインスタンスメソッドを追加してください。  
	
	def SentenceGenerator
	  def gen_hogehoge
	  # ここに生成方法を書く
	  end
	end

という風に書いても構いません

## ライセンス
MIT Licenseです。  

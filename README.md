dbot : $BE,Ev$KJ8>O@8@.$9$k(Bbot
============================
## dbot$B$H$O(B
$B%D%$!<%H$rC18l$d5-9f$4$H$KJ,2r$7$F!"J]B8$7!"J]B8$7$?C18l$+$i!"JQ$JJ8>O$r@8@.$9$k$A$C$A$c$J%=%U%H%&%'%"$G$9(B  
$B!J7ABVAG2r@O$N7k2L$+$i!"7ABVAG4V$N$D$J$,$j$r5-O?$7!"$=$l$rMQ$$$FJ8>O$r@8@.$9$k%=%U%H%&%'%"$G$9!K!#(B

mikutter$B$GF0$/(Bbot$B:n$j$?$+$C$?$N$G!":n$j$^$7$?!#(B

## $B%U%!%$%k$K$D$$$F(B
* dbot.rb  
    $B%a%$%s$N%U%!%$%k$G$9!#(BDB$B@8@.$H%D%$!<%H$NJ,@O$r$3$3$G9T$J$C$F$$$^$9!#(B
* generator.rb  
    $BJ8>O@8@.$N%U%!%$%k$G$9!#J8>O$N@8@.$r$3$3$G9T$$$^$9!#(B
* import\_twilog.rb  
    Twilog$B$+$i%@%&%s%m!<%I$G$-$k(BCSV$B%U%!%$%k$rJ,@O$7!"(BDB$B$KJ]B8$7$^$9!#(B
* mikutter\_dbot.rb
    mikutter$BMQ%W%i%0%$%s$G$9!#(B

## $B%$%s%9%H!<%k(B
$B$*9%$-$J%U%)%k%@$G!"(B`git clone`$B$9$k$@$1$G$9!#(B

* $BDL>o%$%s%9%H!<%k(B
  `$ git clone git@github.com:syusui-s/dbot.git`
* mikutter$B$G;H$&>l9g(B
  ` $ git clone git@github.com:syusui-s/dbot.git ~/.mikutter/plugin/mikutter_dbot`

## $B;H$$J}(B
$B$3$3$G$O!"(Bimport\_twilog.rb$B$r;H$C$F(BDB$B$r:n$j!"$=$N(BDB$B$rMQ$$$FJ8>O@8@.$9$kJ}K!$r=q$$$F$*$-$^$9!#(B

1. Twilog$B$+$i2a5n$N%D%$!<%H$N%"!<%+%$%V(B(UTF-8)$B$r%@%&%s%m!<%I$7!"E83+$9$k!#(B  
  `$ gzip -d username_130522.csv.gz`  
2. import\_twilog.rb $B$rMQ$$$F!"(BDB$B$r@8@.$9$k!#(B  
  $B$3$N:n6H$O;~4V$,$+$+$j$^$9$N$G!"5$D9$K$*BT$A$/$@$5$$!#(B  
  $B<B9T8"8B$,$J$$>l9g$O!"(B`$ chmod +x ./import_twilog.rb`$B$7$F!"<B9T$G$-$k$h$&$K$7$F$/$@$5$$!#(B  
  `$ ./import_twilog.rb username_130522.csv words.db`
  $B%a%b%j$KM>M5$,$"$l$P!"(B/dev/shm/ $B$d(B RAMDISK$B$K(Bcsv$B$H=PNO@h$r;XDj$9$k$H!"$H$F$bAa$/$J$j$^$9!#(B  
  $BNc(B: `$ ./import_twilog.rb /dev/shm/username_130522.csv /dev/shm/words.db`  
  $B:n6H$,=*$o$C$?$i!"(B
3. Ruby$B$N%$%s%?%W%j%?$rN)$A>e$2$k(B  
  Ruby$B$N%$%s%?%W%j%?!J(Birb$B$d(Bpry$B!K$r5/F0$7$^$9!#(B
4. $B;n$7$KJ8>O$r@8@.$7$F$_$^$9(B  
  $B%$%s%?%W%j%?$G<B9T$7$F$_$^$9!#(B  
  ./test.db$B$K$O(B3$B$G:n$C$?(BDB$B%U%!%$%k$N%Q%9$r;XDj$7$F$/$@$5$$!#(B
	require './generator'
	gen=SentenceGenerator.new(WordsDB("./test.db"))
	gen.random
  $B$A$c$s$H=PNO$5$l$l$P@.8y$G$9!#$*$a$G$H$&$4$6$$$^$9!*(B  

## $B@8@.J}K!$NDI2C(B
generator.rb$B$N(BSentenceGenerator$B%/%i%9$K!"!V(Bgen\_$B!W$+$i;O$^$k%$%s%9%?%s%9%a%=%C%I$rDI2C$7$F$/$@$5$$!#(B  

	def SentenceGenerator
	  def gen_hogehoge
	  # $B$3$3$K@8@.J}K!$r=q$/(B
	  end
	end

$B$H$$$&Iw$K=q$$$F$b9=$$$^$;$s(B

## $B%i%$%;%s%9(B
MIT License$B$G$9!#(B

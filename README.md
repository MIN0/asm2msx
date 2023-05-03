# asm2msx  
asm2msxとは  
・Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプト。RUBYとRUSTで記述。  
　今まで手作業でBASIC文を打ち込んでいたのをこのスクリプトで一括変換します。  
　実行ファイルとしてRUSTで作成したasm2msx.rsをコンパイルしたasm2msx.exeを追加しました。  
　asm2msx.exeでZ80のマシン語ファイルをMSX0のBASICファイルに変換してください。  
 
・MSX0は、M5Stack Core2にMSX2+エミュレータを実装したもので、MSX/MSX2/MSX2+のソフトがそのまま動作する。  
　クラウドファンディングで頒布される製品は、M5Stack Core2に、Facesと呼ばれる拡張ユニットが追加された    
  もので、用途に応じてキーボードやゲームパッドを下部に装着できる。  
  　[GAME Watch](https://game.watch.impress.co.jp/docs/kikaku/1468315.html)   
   「次世代MSXプロジェクト第1弾「MSX0」とは何なのか？」より  
   
使い方：  
　１）MSXでのCOMファイルやZ80アセンブラで変換したZ80機械語のEXEファイル（例えばzasm64.exe（注１）を使用）を用意します。  
　２）asm2msx.exe（本変換ツール）で機械語のCOM/EXEファイル形式からMSXのBASICファイルBAS形式に変換する。  
　３）msxterm_v0.2.1_win.zipから取り出したmsxterm.exeでMSXのBASICファイルをMSX0へ転送（コピー＆  
　　　ペースト）する（注２）。  
　　（注意：ウイルス対策ソフトを使用している場合はウイルス対策ソフトを設定して非動作にしてください）  
  
＜実施例＞  
$>asm2msx.exe ＜Z80アセンブラファイル名：xxx.com＞ ＜MSX-BASICファイル名：xxx.bas＞  
$>msxterm -f history.txt 192.168.100.2:2223  
　　この後、msxtermのコマンド（list, new, #load xxx.bas, run, #quit, etc）で無線でつながっているM5stack+MSX等に読み込み／実行する。  
  
```
$> msxterm -f history.txt 192.168.1.105:2223  
192.168.1.105:2223  
history.txt  
Connecting... 192.168.100.2:2223  
connected.  
\> new  
new  
Ok  
\> #load a.bas  
1 clear 100,&hd000  
2 k=&hd000:def usr=k  
3 read x$:if x$="END" then 8  
4 if x$="" then 3  
5 x2$=left$(x$,2):x$=right$(x$,len(x$)-2)  
6 y=val("&h"+x2$):poke k,y:k=k+1  
7 goto 4  
8 a=usr(0):end  
1000 DATA cd9f00fe5ac8cda200473e3dcda20078cb2fcb2fcb  
1010 DATA 2fcb2fc630cda20078e60fc630cda2003e0acda2003e  
1020 DATA 0dcda200c300d0  
1030 DATA END  
\> run  
run  
```

  
・（注１）zasm64.exeとは、シンプルで軽量なZ80アセンブラZASMと、ZASMが動作するように変換してくれるツール  
　MS-DOS Playerで生成した、Windows上で動作するZ80アセンブラです。詳細は以下を参照ください。  
　　[アセンブラでソフトを開発しよう](https://www.tiny-yarou.com/asmdev/asmdev.html)  
  　　（注意：本アセンブラでは16進数を表すには”0xxxxH”で記述してください）  
・（注２）「msxterm とは PC から MSX0 に TCP/IP 接続するための専用ターミナルソフトです。  
　　CUI で主にプログラム作成に使用する事を想定しています。 ＢＡＳＩＣでプログラムを組む際に色々便利  
  　な機能を内蔵しています。  
　　MSX0 の文字コードをフルにサポートしているので文字化けなどの問題が発生しません。」  
 　著作者：akio-seさん  
 　https://github.com/akio-se/msxterm  
  
・asm2msx.rbはRUBYで、asm2msx.rsはRUSTで作成された、Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプトです。
　asm2msx.exeはasm2msx.rsをWindowsマシン用に作成した実行ファイルです。
　使い方はWindowsマシンで（確認はWindows10のみで実施）コマンドプロンプトで以下のように操作してください。  
  
    >asm2msx.exe ＜Z80アセンブラファイル名＞ ＜MSX-BASICファイル名＞　　
  
　＜Z80アセンブラファイル＞にはMSXのCOMファイルやzasm64.exeで変換したファイル（例えばxxx.exe）を、＜MSX-BASICファイル＞  
　にはmsxterm.exeで読み込むファイル（例えばxxx.bas）を記入します。  
　asm2msx,exeの後にファイル名を忘れるなどした場合、エラーが発生しして以下のメッセージが表示されます。  
  
     "Usage: ruby asm2msx.rb <Z80 assembler file> <MSX-BASIC file>"  
  
　asm2msx.exeではCOM／EXEファイルからMSX-BASICファイルに変換します。その際に自動的に行番号の1行目から8行目にDATA文の内容をメモリ上に読み込んで実行する行が追加されます。必要のない場合はその行を削除してからお使いください。  
  

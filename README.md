# asm2msx  
asm2msxとは  
・Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプト。RUBYで記述。  
・MSX0は、M5Stack Core2にMSX2+エミュレータを実装したもので、MSX/MSX2/MSX2+のソフトがそのまま動作する。  
　クラウドファンディングで頒布される製品は、M5Stack Core2に、Facesと呼ばれる拡張ユニットが追加された  
  もので、用途に応じてキーボードやゲームパッドを下部に装着できる。  
  　[GAME Watch](https://game.watch.impress.co.jp/docs/kikaku/1468315.html) 
   「次世代MSXプロジェクト第1弾「MSX0」とは何なのか？」より  
   
使い方：  
　１）zasm64.exeでZ80アセンブラファイルをZ80機械語のEXEファイルへアセンブルする。  
　２）asm2msx.rb（本変換ツール）で機械語のEXEファイル形式からMSXのBASICファイルBAS形式に変換する。  
　３）msxterm_v0.2.1_win.zipから取り出したmsxterm.exeでMSXのBASICファイルをMSX0へ転送する。  
　　（注意：ウイルス対策ソフトを使用していると動作できない場合があります）

・zasm64.exeとは、シンプルで軽量なZ80アセンブラZASMと、ZASMが動作するように変換してくれるツール  
　MS-DOS Playerで生成した実行ファイルです。詳細は以下を参照ください。  
　　[アセンブラでソフトを開発しよう](https://www.tiny-yarou.com/asmdev/asmdev.html)  
・「msxterm とは PC から MSX0 に TCP/IP 接続するための専用ターミナルソフトです。  
　　CUI で主にプログラム作成に使用する事を想定しています。 ＢＡＳＩＣでプログラムを組む際に色々便利  
  　な機能を内蔵しています。  
　　MSX0 の文字コードをフルにサポートしているので文字化けなどの問題が発生しません。」  
 　著作者：akio-seさん  
 　https://github.com/akio-se/msxterm  
  
・asm2msx.rbはRUBYで作成された、Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプトです。  
　使い方はWindowsマシンで（確認はWindows10のみで実施）コマンドプロンプトで以下のように操作してください。  
  
    >ruby asm2msx.rb ＜Z80アセンブラファイル＞ ＜MSX-BASICファイル＞　　
  
　＜Z80アセンブラファイル＞にはzasm64.exeで変換したファイル（例えばxxx.exe）を、＜MSX-BASICファイル＞  
　にはmsxterm.exeにコピー＆ペーストするファイル（例えばxxx.bas）を記入します。  
　エラーが発生したときには以下のメッセージが表示されます。  
  
     "Usage: ruby asm2msx.rb <Z80 assembler file> <MSX-BASIC file>"  
  
　asm2msx.rbでMSX-BASICファイルが変換されると、自動的に行番号の1行目から6行目にzasm64.exeで作成した  
　機械語を実行するためのBASIC文が挿入されます。必要のない場合はその行を削除してからお使いください。  

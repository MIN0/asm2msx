# asm2msx  
asm2msxとは  
・Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプト。RUBYで記述。  
・MSX0は、M5Stack Core2にMSX2+エミュレータを実装したもので、MSX/MSX2/MSX2+のソフトがそのまま動作する。  
　クラウドファンディングで頒布される製品は、M5Stack Core2に、Facesと呼ばれる拡張ユニットが追加されたもの  
 　で、用途に応じてキーボードやゲームパッドを下部に装着できる。  
  　[GAME Watch](https://game.watch.impress.co.jp/docs/kikaku/1468315.html)   
   「次世代MSXプロジェクト第1弾「MSX0」とは何なのか？」より  
   
 使い方：  
 　１）zasm64.exeでZ80アセンブラファイルを機械語のEXEファイルへアセンブルする。  
 　２）機械語のEXEファイルからasm2msx.rb（添付ファイル）でMSXのBASICファイルに変換する。  
 　３）

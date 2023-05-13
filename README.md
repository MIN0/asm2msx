# asm2msx  
asm2msxとは  
・Z80のマシン語ファイルをMSX0のBASICファイルに変換するスクリプト。  
　今まで手作業でBASIC文を打ち込んでいたのをこのスクリプトで一括変換します。  
　実行ファイルとしてRUBYで作成したasm2msx.rbと、RUSTで作成したasm2msx.rsをコンパイルしたasm2msx.exeを追加しました。  
　asm2msx.exeでZ80のマシン語ファイルをMSX0のBASICファイルに変換できます。  
　asm2msx.exeは画面の上にあるasm2msx.exeをクリックして、次の画面の右側のdownloadをクリックして  
　ください。削除されるようでしたら、お使いのウイルス対策ソフトを設定して非動作にしてください。
 
・MSX0は、M5Stack Core2にMSX2+エミュレータを実装したもので、MSX/MSX2/MSX2+のソフトがそのまま動作する。  
　クラウドファンディングで頒布される製品は、M5Stack Core2に、Facesと呼ばれる拡張ユニットが追加された    
  もので、用途に応じてキーボードやゲームパッドを下部に装着できる。  
  　[GAME Watch](https://game.watch.impress.co.jp/docs/kikaku/1468315.html)   
   「次世代MSXプロジェクト第1弾「MSX0」とは何なのか？」より  
   
使い方：  
　１）MSXでのCOMファイルやZ80アセンブラで変換したZ80機械語のEXEファイル（例えばzasm64.exe（注１）  
　　　で機械語ファイルに生成）を用意します。  
　２）asm2msx.exe（本変換ツール）で機械語のCOM/EXEファイル形式からMSXのBASICファイルBAS形式に変換  
　　　する。  
　３）msxterm_v0.2.1_win.zipから取り出したmsxterm.exeでMSXのBASICファイルをMSX0へ転送（コピー＆  
　　　ペースト）する（注２）。msxtermのコマンド（list, new, #load xxx.bas, run, #quit, etc）で無線  
　　　でつながっているMSX0に読み込み／実行する。実行前にmsxtermの内部コマンドで#lowsend_offを実行  
　　　してください。  
　　（注意：ウイルス対策ソフトを使用している場合はウイルス対策ソフトを設定して非動作にしてください）  
  
＜実施例＞  
  
サンプルプログラムには次のWEBページを例にしました。  
[Z80アセンブラを思い出してみる](https://tech.synapse.jp/entry/2022/12/01/150000#%E5%85%A5%E5%8A%9B%E3%81%97%E3%81%9F%E6%96%87%E5%AD%97%E3%81%AE%E6%96%87%E5%AD%97%E3%82%B3%E3%83%BC%E3%83%89%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0)  
  
```
C:\asm2msx>type key_in.asm    
CHGET:      EQU 0009FH          ;キーボードから1文字読み取るBIOS  
CHPUT:      EQU 000A2H          ;画面に1文字出力するBIOS  
  
            ORG 0D000H          ;プログラムをD000番地から開始する  
START:  
  
MAINLOOP:  
            CALL CHGET          ;キーボードから1文字読み込む  
            CP 90               ;Aレジスタの内容を大文字の Z と比較し  
            RET Z               ;一致すればプログラム終了  
            CALL CHPUT          ;入力された文字をそのまま1文字表示　  
            LD B,A              ;入力された文字を一旦Bレジスタに退避  
            LD A,"="            ;Aレジスタに = の文字コードをセットし  
            CALL CHPUT          ;= を表示  
            LD A,B              ;Bレジスタの値を再度Aレジスタに読み込み  
            SRA  A              ;右に1ビットシフト  
            SRA  A              ;右に1ビットシフト  
            SRA  A              ;右に1ビットシフト  
            SRA  A              ;右に1ビットシフト  
            ADD A,30h           ;Aレジスタの値に30を足し、アスキーコードに変換  
            CALL CHPUT          ;1文字表示  
            LD A,B              ;Bレジスタの値を再度Aレジスタに読み込み  
            AND 00001111b       ;下位4ビットのみ取り出し  
            ADD A,30h           ;Aレジスタの値に30を足し、アスキーコードに変換  
            CALL CHPUT          ;1文字表示  
            LD A,10             ;改行(LF)  
            CALL CHPUT  
            LD A,13             ;復帰(CR)  
            CALL CHPUT  
            JP MAINLOOP         ;ループ先頭に戻る  
  
END  
  
  
C:\asm2msx>zasm64 -Z -Ckey_in.bin -Lkey_in.prn key_in.asm  
/// ZASM /// Z-80 Assembler, MS-DOS version 1.64  
Copyright (C) 1988-1994 by K.KAWABATA (Bunbun)  
  
** Pass 1 **  Symbol table size  2000 Symbols  
** Pass 2 **  
  
  0 warning(s),   0 error(s) in assembly.  
  
  
C:\asm2msx>asm2msx.exe key_in.bin key_in.bas  
  
  
C:\asm2msx>msxterm -f history.txt 192.168.100.2:2223  
192.168.100.2:2223  
history.txt  
Connecting... 192.168.100.2:2223  
connected.  
> new  
new  
Ok  
> #load key_in.bas  
1 clear 100,&hd000  
2 k=&hd000:def usr=k  
3 read x$:if x$="end" then 8  
4 if x$="" then 3  
5 x2$=left$(x$,2):x$=right$(x$,len(x$)-2)  
6 y=val("&h"+x2$):poke k,y:k=k+1  
7 goto 4  
8 a=usr(0):end  
1000 data cd9f00fe5ac8cda200473e3dcda20078cb2fcb2fcb  
1010 data 2fcb2fc630cda20078e60fc630cda2003e0acda2003e  
1020 data 0dcda200c300d0  
1030 data end  
> #lowsend_off  
Lower Case send mode Off  
> run  
run  
  
> a　　　→小文字のａを入力  
a=61  
=0=  
> A　　　→大文字のＡを入力  
A=41  
=0=  
> z　　　→小文字のｚを入力  
z=7:  
=0=  
> Z　　　→大文字のＺを入力  
Ok　　　　→実行を終了する  
  
>  
```
  
  
・（注１）zasm64.exeとは、シンプルで軽量なZ80アセンブラZASMと、ZASMが動作するように変換してくれる  
　ツールMS-DOS Playerで生成した、Windows上で動作するZ80アセンブラです。詳細は以下を参照ください。  
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
  
　＜Z80アセンブラファイル＞にはMSXのCOMファイルやzasm64.exeで変換したファイル名（例えばxxx.exe）を、  
　＜MSX-BASICファイル＞にはmsxterm.exeで読み込むファイル名（例えばxxx.bas）を記入します。  
　asm2msx,exeの後にファイル名を忘れるなどした場合、エラーが発生して以下のメッセージが表示されます。  
  
     "Usage: ruby asm2msx.rb <Z80 assembler file> <MSX-BASIC file>"  
  
　asm2msx.exeではCOM／EXEファイルからMSX-BASICファイルに変換します。その際に自動的に行番号の1行目から8行目にDATA文の内容をメモリ上に読み込んで実行する行が追加されます。必要のない場合はその行を削除してからお使いください。  
  

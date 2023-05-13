#
# Title: asm2msx.rb
# Creation date: May 13, 2023
# Revision: 0.20
# Creator: Minoru Kishi (Twitter:MIN0_KABE)
#
# タイトル：asm2msx.rb
# 作成日：2023年05月13日
# レビジョン：0.20
# 作成者：Minoru Kishi (Twitter:MIN0_KABE)
# 

#初期設定
ln=1000                                          # lnは一番最初の行番号
str=ln.to_s(10)+" data "                         # strは一行分のBASICのDATA行（作業用）。初期値は"1000 DATA "
str2=""                                          # str2は取り出したいBASICのDATA行の固まり。
                                                 # ここ（<<"EOS"）から最後のEOSの間にある複数行をtextとする
text=<<"EOS"
1 clear 100,&hd000
2 k=&hd000:def usr=k
3 read x$:if x$="end" then 8
4 if x$="" then 3
5 x2$=left$(x$,2):x$=right$(x$,len(x$)-2)
6 y=val("&h"+x2$):poke k,y:k=k+1
7 goto 4
8 a=usr(0):end
EOS

#Z80アセンブラファイルの読み込み（エラー処理）
begin
    io = open(ARGV[0])
rescue
    # "使い方：ruby asm2msx.rb ＜Z80アセンブラファイル＞ ＜MSX-BASICファイル＞"
    p "Usage: ruby ​asm2msx.rb <Z80 assembler file> <MSX-BASIC file>"
    return
end

#Z80アセンブラファイルの読み込み（MSX-BASIC文への変換処理）
io.each_byte{|ch|                                # each_byteはASCIIコードを返す。
    str=str+ ("0"+ch.to_s(16)).slice(-2,2)       # 2桁の16進数を文字列でstrに追加する。
    if str.length>=4+1+4+1+2*20 then              # strの長さが２桁の１６進数８個になったら以下を実行する。
        str2=str2+ str+"\n"                      #   str2に１行分を追加
        ln+=10                                   #   行番号を次の行番号に進める
        str=ln.to_s(10)+" data "                 #   次の行の頭の部分を挿入（例："1010 DATA "）
    else                                         # それ以外の場合に以下を実行する。
    end
}
io.close                                         # Z80アセンブラファイルの読み込みを終了する

#Z80アセンブラファイルの読み込み（MSX-BASIC文最後の行の変換処理その１）
if str.length==4+1+4+1 then                      # 最後の行が次の行の頭の部分だけだったらそれを削除する
    str=""
end
str2=str2+str+"\n"                               # 最後の行－１をstr2に追加する

#Z80アセンブラファイルの読み込み（MSX-BASIC文最後の行の変換処理その２）
ln+=10                                           # 行番号を次の行番号に進める
str=ln.to_s(10)+" data end"                      # DATAの終わりの印（"END"）を作成する
str2=str2+str+"\n"                               # 最後の行をstr2に追加する


#MSX-BASIC文の書き出し（エラー処理）
begin
file = File.open(ARGV[1], "w")
rescue
    #使い方：ruby asm2msx.rb ＜Z80アセンブラファイル＞ ＜MSX-BASICファイル＞
    p "Usage: ruby asm2msx.rb <Z80 assembler file> <MSX-BASIC file>"
    return
end

#MSX-BASIC文の書き出し
file.write(text)                                 # textを全部保存する
file.write(str2)                                 # 続けて、str2を全部保存する
file.close                                       # 書き出しのクローズ


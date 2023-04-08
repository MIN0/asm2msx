#
# Title: asm2msx.rb
# Creation date: April 08, 2023
# Revision: 0.10
# Creator: Minoru Kishi (Twitter:MIN0_KABE)
# タイトル：asm2msx.rb
# 作成日：2023年04月08日
# レビジョン：0.10
# 作成者：Minoru Kishi (Twitter:MIN0_KABE)
# 

#初期設定
ln=1000                                          # lnは一番最初の行番号
str=ln.to_s(10)+" DATA "                         # strは一行分のBASICのDATA行（作業用）。初期値は"1000 DATA "
str2=""                                          # str2は取り出したいBASICのDATA行の固まり。
text=<<"EOS"                                     # ここ（<<"EOS"）から最後のEOSの間にある複数行をtextとする
1 CLEAR 100,&HD000
2 K=&HD000:DEF USR=K
3 READ X$:IF X$="END" THEN 6
4 Y=VAL("&H"+X$):POKE K,Y:K=K+1
5 GOTO 3
6 A=USR(0)
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
    if str.length>=4+1+4+1+3*8 then              # strの長さが２桁の１６進数８個になったら以下を実行する。
        str2=str2+ str+"\n"                      #   str2に１行分を追加
        ln+=10                                   #   行番号を次の行番号に進める
        str=ln.to_s(10)+" DATA "                 #   次の行の頭の部分を挿入（例："1010 DATA "）
    else                                         # それ以外の場合に以下を実行する。
        str=str+","                              #   2桁の16進数を次の2桁の16進数につなげるコンマを追加する
    end
}
io.close                                         # Z80アセンブラファイルの読み込みを終了する

#Z80アセンブラファイルの読み込み（MSX-BASIC文最後の行の変換処理その１）
if str.length==4+1+4+1 then                      # 最後の行が次の行の頭の部分だけだったらそれを削除する
    str=""
elsif str[-1,1]=="," then                        # 途中まで2桁の16進数が並んでいる場合、最後のコンマを削除する
    str.slice!(-1,1)
end
str2=str2+str+"\n"                               # 最後の行－１をstr2に追加する

#Z80アセンブラファイルの読み込み（MSX-BASIC文最後の行の変換処理その２）
ln+=10                                           # 行番号を次の行番号に進める
str=ln.to_s(10)+" DATA END"                      # DATAの終わりの印（"END"）を作成する
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


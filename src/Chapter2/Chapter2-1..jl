# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.4
#   kernelspec:
#     display_name: Julia 1.8.5
#     language: julia
#     name: julia-1.8
# ---

versioninfo()

# ## 2-1. リテラル

# ### 2-1-1. 数値リテラル

# #### 整数値

# ##### コード2-1. 整数リテラルの例(1)

1

-12345

1_000_000_000

0x123456789abcdef

0o1234567

0b11010101

# ##### コード2-2. 整数リテラルの例(2)

int128"18446744073709551616"

uint128"18446744073709551616"

big"18446744073709551616"

# #### 浮動小数点数値

# ##### コード2-3. 浮動小数点数リテラルの例(1)

1.0

-2.

.1

1_000.000_000

3.1416e2

1e-17

1f10

0x1f.8p0

# ##### コード2-4. 浮動小数点数リテラルの例(2)

big"3.141592653589793238462643383279502884197169399375105820974944592307816406286208"

big"1e-308"

big"0x1fp99"

# #### 有理数/複素数

# ##### コード2-5. 有理数リテラルの例

1//2

-12//20

3//0

# ##### コード2-6. 複素数リテラルの例

im

1 + im

2.0 + 3.2im

# ### 2-1-2. 文字リテラル/文字列リテラル

# #### 文字

# ##### コード2-7. 文字リテラルの例(1)

'a'

'π'

'あ'

'漢'

'😄'

# ##### コード2-8. 文字リテラルの例(2)

'\n'

'\''

'\x41'

'\u32ff'

# #### 文字列

# ##### コード2-9. 文字列リテラルの例(1)

"a"

"abcあいう漢字"

""

"\x41a\u3042"

"複数行文字列
    2行目（インデント：4）
3行目"

"""
複数行文字列
    2行目（インデント：4）
3行目"""

# ##### コード2-10. 文字列リテラルの例(2)

println("
  最初の改行は反映されて↑に空行ができる
    \" ←エスケープ必要
  ←ここもインデントされる")

println("""
  最初の改行は反映されず↑に空行ができない
    " ←エスケープ不要
  ←ここはインデントされない""")

# ##### コード2-11. 文字列リテラルの式展開

x = 1;

"x = $x"

"$(x)x$x"

"Odd Number: $(2x + 1)"

# ##### コード2-12. raw文字列リテラルの例

b = 9;

raw"a\t$b\n\u3042"

println(raw"a\t$b\n\u3042")

"a\t$b\n\u3042"

println("a\t$b\nc")

# ### 2-1-3. 正規表現リテラル

# #### コード2-13. 正規表現リテラルの例

r"^a[b-f]+$"

r"^a[b-f]+$"i

# ### 2-1-4. 非標準文字列リテラル

# #### 表2-1. 非標準文字列リテラル

# | 表記 | 名称 | 例 | 説明 |
# | :-- | :-- | :-- | :-- |
# | `b"～"` | バイト列リテラル | `b"\x89PNG\r\n\x1a\n"` | 文字列ではなく（UTF-8エンコードの）バイト列（`UInt8` の1次元配列）を返す |
# | `MIME"～"` | MIMEタイプリテラル | `MIME"text/html"` | MIMEタイプ[^MIME_TYPE]を表す |
# | `html"～"` | HTMLリテラル | `html"<p>a<br>b</p>"` | HTMLオブジェクトを生成 |
# | `text"～"` | Textリテラル | `text"Text Node"` | Textオブジェクトを生成 |
# | `v"～"` | バージョン番号リテラル | `v"1.6.0-beta1.0"` | バージョン番号（セマンティックバージョニング準拠）を表す |
# | `var"～"` | 変数参照リテラル | `var"#example#"` | 特殊な名前の変数を参照する |

# ### 2-1-5. 範囲リテラル

# #### コード2-14. 範囲リテラルの例

1:10

1:10 == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

1:2:10

1:2:10 == [1, 3, 5, 7, 9]

5:-1:1

5:-1:1 == [5, 4, 3, 2, 1]

0.0:0.1:1.0

collect(0.0:0.1:1.0)

'a':'j'

collect('🕐':'🕛')

# ### 2-1-6. 配列リテラル

# #### ベクトル（1次元配列）

# ##### コード2-15. 配列リテラルの例(1)：ベクトル（1次元配列）

[1, 2, 3]

[1.0, 2.0, 3.0]

['a', 'あ', '😄']

["abc", "あいう", "漢字"]

Float32[1.0, 2.0, 3.0]

[1, 2.0, 3//4]

Number[1, 2.0, 3//4]

# #### 行列（2次元配列）

# ##### コード2-16. 配列リテラルの例(2)：行列（2次元配列）

[1 2
 3 4]

[1 2; 3 4]

[1. 2.; 3. 4.; 5. 6.]

Float32[1. 2. 3.; 4. 5. 6.]

[1 2 3]

# #### 多次元配列（Julia v1.7以降）

# ##### コード2-17. 配列リテラルの例(3)：多次元配列

[1; 2;; 3; 4]

[1;2;;3;4;;;5;6;;7;8]

[1 2;3 4;;;5 6;7 8]  # 従来の行列のリテラル記法との組合せも可能（要素の順番に注意）

[1 2
 3 4
 ;;;
 5 6
 7 8]  # このようにも書ける（より直感的）

[1 + 1;; 2 + 2;; 3 + 3]  # `[(1 + 1) (2 + 2) (3 + 3)]` と同じ

Float32[0;;;;]

# #### ベクトル・行列の結合

# ##### コード2-18. 配列リテラルの例(4)：ベクトル・行列の結合(1)

[[1, 2, 3]; [2, 4, 6]]

[1:3; 2:2:6]

[1:3; 2; 4; 6]

[1:3
 2
 4
 6]

[1:3 [2, 4, 6]]

[[1 2; 3 4] [2 4; 6 8]]

[[1 2; 3 4]; [2 4; 6 8]]

[[1 2; 3 4] [5, 6]]

[[1 2; 3 4]; [5 6]]

[[1 2; 3 4] 5:6
 [7 8]      9]

# ##### コード2-19. 配列リテラルの例(5)：ベクトル・行列の結合(2)

[[1, 2] 3]

[[1 2]; 3]

# 多次元配列の結合（Julia v1.7 以降）

# ##### コード2-20. 配列リテラルの例(6)：多次元配列の結合

[1:3;; [2, 4, 6]]  # `[1:3 [2, 4, 6]]` と同等

[[1;2;;3;4];;[2;4;;6;8]]  # `[[1 3; 2 4] [2 6; 4 8]]` と同等

[[1 2;;;3 4];;[5;;;6]
 ;;;
 [7 8]      ;;9]

[1:3...;;;;]

# ### 2-1-7. タプルリテラル/名前付きタプルリテラル

# #### コード2-21. タプルリテラルの例

(1, 2)

('a', 2, 99.9, π)

(1,)

()

# #### コード2-22. 名前付きタプルリテラルの例(1)

(a=1, b=2)

(c='a', i=2, fp=99.9, pi=π)

(;a=1)  # `(a=1,)` と書いても同じ

(;)  # 値が0個の名前付きタプル

# #### コード2-23. 名前付きタプルリテラルの例(2)

i = 2; fp = 99.9;

(;i, pi)  # `pi` は定数 `π`

(c='a', i, fp, pi)

# ### 2-1-8. その他のリテラル

# #### 表2-2. その他のリテラル

# | リテラル表記 | 種類 | 説明 |
# | :-- | :-- | :-- |
# | `true`/`false` | 真偽値リテラル | `Bool` 型の値（2種類のみ） |
# | `nothing` | `nothing` リテラル | `Nothing` 型の値（1種類のみ） |
# | `missing` | 欠損値リテラル | `Missing` 型の値（1種類のみ） |
# | `:ok` 等 | シンボルリテラル | `Symbol` 型（`:` に続く文字列表記） |
# | `` `ls` `` 等 | コマンドリテラル | `Cmd` 型（シェルコマンドを表す） |


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

# ## 2-6. その他の構文

# ### 2-6-1. 内包表記

# #### コード2-78. 内包表記の例(1)：ベクトルの生成(1)

[n^2 for n = 0:10]

[n-1 for n = 0:10 if n % 3 != 0]

# #### コード2-79. 内包表記の例(2)：ベクトルの生成(2)

Float32[√x for x=0:10]

# #### コード2-80. 内包表記の例(3)：行列・多次元配列の生成

[10x + y for x=1:3, y=1:3]

[100x + 10y + z for x=1:4, y=1:5, z=1:3]

# #### コード2-81. 内包表記の例(4)：条件節の指定

[100x + 10y + z for x=1:4, y=1:5, z=1:3 if isodd(x)]

# #### コード2-82. 内包表記の例(5)：ベクトルの生成(3)

[100x + 10y + z for z=1:3 for y=1:5 for x=1:4]

# #### コード2-83. 内包表記の例(6)：ジェネレータ式

(n^2 for n = 0:10)

# ### 2-6-2. ドット構文

# #### コード2-84. ドット構文の例(1)：関数への適用

sin(1.0)

sin.([1.0, 2.0, 3.0])

f(x) = x^2 - 2x + 1

f.([-2.0, -1.0, 0.0, 1.0, 2.0])

# #### コード2-85. ドット構文の例(2)：演算子への適用

x = [1.0, 2.0, 3.0];

y = [2.0, 3.0, 1.0];

x + y

x .+ y

x * y

x .* y

# ### 2-6-3. Doブロック構文

# #### コード2-86. Doブロック構文の例(1)：無名関数との比較

map(x -> x^2 + 2x - 1, 1:10)

map(1:10) do x
    x^2 + 2x - 1
end

# #### 仮想コード2-3. テキストファイル sample.txt の内容確認

#=
$ cat sample.txt
それはCのように高速だけど、Ruby のようなダイナミズムを併せ持っていてほしい。
同図像性のある言語で、Lisp のような真のマクロを持ちながら、
MATLAB のような直感的な数式表現もできるものが欲しい。
Python のように総合的なプログラミングができて、R のように統計処理も得意で、
Perl のように文字列処理もできて、MATLAB のように線形代数もできて、
shell のように複数のプログラムを組み合わせることもできるものが欲しい。
超初心者にも習得は容易でありながら、ハッカーの満足にも応えられるものであってほしい。
インタラクティブな動作環境もあって、コンパイルもできるものであってほしい。
（Cと同じくらい高速に、はもう言ったっけ？）
=#

#=
;cat sample.txt
=#

# #### コード2-87. Doブロック構文の例(2)：`open()` との組合せ

open("sample.txt") do f
    for line in eachline(f)
        println(line)
    end
end

# #### 仮想コード2-4. Doブロック構文と等価なコード（`open()` の例）

# ```julia
# f = open("sample.txt");
# try
#     for line in eachline(f)
#         println(line)
#     end
# finally
#     close(f)
# end
# ```

# ### 2-6-4. `begin` ブロックと `let` ブロック

# #### コード2-88. `begin` ブロックの例

a = b = 0.0;

begin
    x = rand() * 10
    a = cos(x)
    b = sin(x)
    a * a + b * b
end

x

a

b

# #### コード2-89. `let` ブロックの例(1)

c = d = 0.0

let 
    y = rand() * 10
    c = cos(y)
    d = sin(y)
    c * c + d * d
end

c

d

y

# #### コード2-90. `let` ブロックの例(2)

x = Float64(π)

y = 1.0

a = b = 0.0

let x = x, y = y
    x, y = y, x
    a = cos(x)
    b = sin(x) * cos(y)
    c = sin(x) * sin(y)
    a * a + b * b + c * c
end

x, y, a, b

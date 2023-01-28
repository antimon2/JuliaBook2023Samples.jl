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

# ## 2-7. 型の基本

# ### 2-7-1. プリミティブ型

# #### プリミティブ整数型

# #### コード2-91. `Int`/`UInt` の確認

Int

UInt

# #### コード2-92. 整数リテラルの型の確認

typeof(1)

typeof(2147483647)

typeof(2147483648)

typeof(9223372036854775807)

typeof(9223372036854775808)

typeof(170141183460469231731687303715884105727)

typeof(170141183460469231731687303715884105728)

typeof(0x0) == typeof(0xff) == 
typeof(0o0) == typeof(0o377) == 
typeof(0b0) == typeof(0b11111111) == UInt8

typeof(0x000) == typeof(0xffff) == 
typeof(0o400) == typeof(0o177777) == 
typeof(0b000000000) == typeof(0b1111111111111111) == UInt16

typeof(0x00000) == typeof(0xffffffff) == 
typeof(0o200000) == typeof(0o37777777777) == 
typeof(0b00000000000000000) == 
typeof(0b11111111111111111111111111111111) == UInt32

# 以降煩雑になるので16進表記リテラルのみ示す
typeof(0x000000000) == typeof(0xffffffffffffffff) == UInt64

typeof(0x00000000000000000) == 
typeof(0xffffffffffffffffffffffffffffffff) == UInt128

typeof(0x000000000000000000000000000000000) == 
typeof(0x100000000000000000000000000000000) == BigInt

# #### コード2-93. 整数（リテラル）の型変換例

Int8(1)
# REPL の見た目上は区別が付かない

typeof(Int8(1))

Int8(257)

257 % Int8  # こちらはエラーにならない

typeof(257 % Int8)

UInt16(4660)

4660 % UInt16

typeof(UInt16(4660)) == typeof(4660 % UInt16) == UInt16

# #### プリミティブ浮動小数点数型

# #### コード2-94. 浮動小数点数（リテラル）の型の確認と型変換例

typeof(1.0)

typeof(1e0)

typeof(1f0)

typeof(0x1p0)

Float16(1)

Float32(1.0)

Float16(65535)  # 65535 > floatmax(Float16) == 65504.0

# #### その他の標準プリミティブ型

# ### 2-7-2. 複合型

# #### コード2-95. 複合型の例(1)：簡単な定義例

struct Point
    x
    y
end

pt = Point(1.0, 2.0)

pt.x

pt.y

# #### コード2-96. 複合型の例(2)：有理数と複素数のフィールド

r = 1//2

r.num

r.den

c = 1.0 + 2.0im

c.re

c.im

# #### コード2-97. 有理数と複素数のフィールドと同じ値を返す関数

numerator(r)

denominator(r)

numerator(2)

denominator(2)

real(c)

imag(c)

real(2.0)

imag(2.0)

# ### 2-7-3. コレクション型

# #### 配列

# ##### コード2-98. 配列の型の確認

typeof([1, 2, 3])

typeof([1.0 2.0; 3.0 4.0; 5.0 6.0])

typeof([100x + 10y + z for x=1:4, y=1:5, z=1:3])

# ##### コード2-99. インデクシング(1)：ベクトルのインデクシング参照

v = [1, 2, 3];

v[1]

v[2]

v[0]　　# v[-1], v[4] 等も同様

v[begin]

v[end]

v[end-1]

# ##### コード2-100. インデクシング(2)：ベクトルのインデクシング代入

v[2] = 0

v

v[4] = 99

# ##### コード2-101. インデクシング(3)：行列（多次元配列）のインデクシング（多次元インデックス）

M = [1.0 2.0; 3.0 4.0; 5.0 6.0];

M[1, 1]

M[3, 2]

M[CartesianIndex(3, 2)]

M[2, 3]

M[begin, begin]

M[end, end]

M[2, 2] = 0.0

M

M[CartesianIndex(2, 2)] = 10.0

M

# ##### コード2-102. インデクシング(4)：行列（多次元配列）のインデクシング（線形インデックス）

M = [1.0 2.0; 3.0 4.0; 5.0 6.0]

M[1]

M[2]

M[3]

M[4]

M[5]

M[6]

# ##### コード2-103. インデクシング(5)：範囲指定

v = [1, 0, 3]

v[1:2]

M = [1.0 2.0; 3.0 4.0; 5.0 6.0]

M[1:2, 1]

M[1, :]

M[1:1, :]

M[1:2, 1:1]

# ##### コード2-104. インデクシング(6)：論理式によるフィルタリング

M[M .> 3]

# #### 辞書

# ##### コード2-105. 辞書の例(1)：定義とキー参照

d = Dict(:a => 1, :b => 2, :c => 3)

d[:a]

d[:n]

# ##### コード2-106. 辞書の例(2)：エントリーの登録と更新

d[:b] = 20  # エントリーの更新

d[:e] = 5  # エントリーの登録

d

# ##### コード2-107. 辞書の例(3)：キーと値の型（エラー例）

d[:pi] = π

d["Invarid Key"] = -1

# #### 集合

# ##### コード2-108. 集合の例(1)：定義

s = Set([3, 1, 4, 1, 5, 9, 2, 6, 5, 3])

# ##### コード2-109. 集合の例(2)：イテレーション、`in` 演算子

for n in s
    println(n)
end

3 ∈ s

0 ∉ s

# ##### コード2-110. 集合の例(3)：要素の追加と削除

push!(s, 0)

push!(s, 9)

pop!(s, 0)

s

# #### タプル/名前付きタプル

# ##### コード2-111. タプルの例（定義・インデクシング参照）

t = ('a', 2, 99.9, π)

t[1]

t[4]

t[3] = 10.0

push!(t, "Not Available")

# ##### コード2-112. 名前付きタプルの例（定義・インデクシング参照・キー参照・プロパティ参照）

nt = (c='a', i=2, f=99.9, pi=π)

nt.c

nt[:i]

nt[3]

nt.notexists

nt.f = 10.0

nt[:notexists] = "New Value"

# ### 2-7-4. 文字列型

# #### コード2-113. 文字列型の例

str = "abcあいう😄漢字"

str[1]

str[4]

str[7]

str[13]

str[17]

str[12]

# ### 2-7-5. 型アノテーション

# #### コード2-95. 複合型の例(1)：簡単な定義例（再掲）

# ```julia
# julia> struct Point
#            x
#            y
#        end
#
# julia> pt = Point(1.0, 2.0)
# Point(1.0, 2.0)
#
# julia> pt.x
# 1.0
#
# julia> pt.y
# 2.0
# ```

# #### コード2-114. 型アノテーション(1)：複合型のフィールドへの型アノテーション

struct IntPoint
    x::Int
    y::Int
end

IntPoint(1, 3)

IntPoint(2.0, 3.2)

# #### コード2-115. 型アノテーション(2)：ローカル変数への型アノテーション（＝変数の型の指定）

function typeannotatesample()
    n::Int = 0
    n = 3.0
    n
end

result = typeannotatesample()

typeof(result)

# #### コード2-116. 型アノテーション(3)：式への型アノテーション（＝型検査）

function typeassertsample(fn::Function)
    n = fn()::Int
    n
end

typeassertsample() do
    1 + 2
end

typeassertsample() do
    sin(π)
end



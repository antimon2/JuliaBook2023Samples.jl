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

# ## 3-3. 関数・引数の組合せ

# ### 3-3-1. 文字列→数値変換

# #### コード3-65. 文字列→数値変換(1)

parse(Int, "123")

parse(UInt, "123")

parse(UInt8, "123")

typeof(parse(Int32, "123"))

parse(Float64, "123")

parse(Float64, "123.45")

# + tags=[]
parse(Int, "123.45")

# + tags=[]
parse(Int8, "200")
# -

typeof(tryparse(Int, "123.45"))

typeof(tryparse(Int8, "200"))

# #### コード3-66. 文字列→数値変換(2)

parse(Complex{Int}, "1+2im")

parse(ComplexF64, "1.0 + 2.3im")

# #### コード3-67. 文字列→日付/UUID変換

using Dates

parse(Date, "2021-03-31")  # `Date("2021-03-31")` と同等

parse(DateTime, "2021/3/14 15:9:26.535", dateformat"yyyy/mm/dd HH:MM:SS.sss")

using UUIDs

parse(UUID, "c9d0f6c5-a316-4218-9137-307c04cbbadd")

# ### 3-3-2. 数値の丸め処理

# #### コード3-68. 数値の丸め(1)：`round()` 関数

x = 123.375

round(x)

round(x, digits=2)

round(x, digits=-1)

round(x, sigdigits=2)

round(x, base=2)

round(x, digits=2, base=2)

round(x, digits=-1, base=2)

round(x, sigdigits=2, base=2)

# #### コード3-69. 数値の丸め(2)：整数値への丸め

x = 123.5;

round(Int, x)

round(UInt8, x)

trunc(Int, x)

floor(Int, x)

ceil(Int, x)

# ### 3-3-3. `all()`/`any()`

# #### コード3-70. `all()`/`any()` の使用例（性能比較）

using BenchmarkTools

X = [2:2:100000; -1];  # 50000個の偶数と「-1」からなる配列（ベクトル）

@btime all(iseven, $X)

@btime all(iseven(x) for x in $X)

@btime all(iseven.($X))

@btime any(<(0), $X)

@btime any(x < 0 for x in $X)

@btime any($X .< 0)

# ### 3-3-4. 引数にジェネレータ式を指定出来るその他の例

# #### コード3-71. 引数にジェネレータ式を指定出来るその他の例

using BenchmarkTools

X = [2:2:100000; -1];

@btime sum(x->2x-1, $X)

@btime sum(2x-1 for x in $X)

@btime sum($X .|> x->2x-1)

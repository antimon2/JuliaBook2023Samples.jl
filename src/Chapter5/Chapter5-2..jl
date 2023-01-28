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

# ## 5-2. 多重定義

# ### 5-2-1. 関数の定義（おさらい）

# #### コード5-1.	関数定義の例(1)

function add(x, y)
    x + y
end

add(x, y) = x + y

# #### コード5-2.	関数定義の例(2)

add(x, y, z) = x + y + z

function add(x, y, z...)
    add(x + y, z...)
end

# #### コード5-3.	多重定義した関数のメソッドの確認

methods(add)

# ### 5-2-2. 型シグニチャ

# #### コード5-4.	型シグニチャによる関数の多重定義例 (1)

double(x) = 2x

double(s::AbstractString) = s ^ 2

# #### コード5-5.	`double()` 関数の実行例 (1)

double(100)

double(1.23)

double(π)

# #### コード5-6.	`double()` 関数の実行例 (2)

double("ABC")

double(strip("  ABCD  "))

# #### コード5-7.	型シグニチャによる関数（`double()`）の多重定義例 (2)

double(x, y) = string(double(x), double(y))

double(x::Number, y::Number) = double(x) + double(y)

double("ABC", "あいう")

double(2, "A")

double("😄", 0.2)

double(3, π)

# #### コード5-8.	`Base.typesof()` 関数の例

Base.typesof("ABC", "あいう")

Base.typesof(2, "A")

Base.typesof("😄", 0.2)

Base.typesof(3, π)

# #### コード5-9.	`Base.typesof()` の結果と型シグニチャのサブタイピング

Tuple{Number, Number} <: Tuple{Any, Any}

Tuple{Any, Any} <: Tuple{Number, Number}

Base.typesof("ABC", "あいう") <: Tuple{Any, Any}

Base.typesof("ABC", "あいう") <: Tuple{Number, Number}

Base.typesof(2, "A") <: Tuple{Any, Any}

Base.typesof(2, "A") <: Tuple{Number, Number}

Base.typesof("😄", 0.2) <: Tuple{Any, Any}

Base.typesof("😄", 0.2) <: Tuple{Number, Number}

Base.typesof(3, π) <: Tuple{Any, Any}

Base.typesof(3, π) <: Tuple{Number, Number}

# ### 5-2-3. 実例

# #### コード5-10.	MyTime1.jl

# +
abstract type AbstractTime end

function gethour end
function getminute end
function getsecond end

function Base.show(io::IO, time::AbstractTime)
    print(io,
          string(gethour(time), pad=2),
          ':',
          string(getminute(time), pad=2),
          ':',
          string(getsecond(time), pad=2))
end

struct MyTime <: AbstractTime
    hour::Int
    minute::Int
    second::Int
end

gethour(time::MyTime) = time.hour
getminute(time::MyTime) = time.minute
getsecond(time::MyTime) = time.second

struct MyTime2 <: AbstractTime
    seconds::Int
end

gethour(time::MyTime2) = time.seconds ÷ 3600
getminute(time::MyTime2) = time.seconds ÷ 60 % 60
getsecond(time::MyTime2) = time.seconds % 60
# -

# #### コード5-11.	`MyTime` 型の利用例

mytime = MyTime(12, 34, 56)

string(mytime)

# #### コード5-12.	`MyTime2` 型の利用例

mytime2 = MyTime2(10000)  # 午前0時の10000秒後は 2時46分40秒

string(mytime2)

# ### 5-2-4. メソッドの曖昧さの解決

# #### コード5-13.	型シグニチャによる関数（`double()`）の多重定義例 (3)

double(x::Number, y::Float64) = double(x) + 2double(y)

double(x::Float64, y::Number) = 2double(x) + double(y)

# #### コード5-14.	`double()` 関数の実行例 (3): メソッドの曖昧さによるエラー例

double(1, 2.0)

double(1.0, 2)

double(1.0, 2.0)

# #### コード5-15.	型シグニチャによる関数（`double()`）の多重定義例 (4)

double(x::Float64, y::Float64) = 2double(x) + 2double(y)

double(1.0, 2.0)

# #### コード5-16.	型シグニチャの不整合による「メソッドが見つからない」エラー例

_double(s::String) = s^2

_double(strip("   ABCD   "))

# ### コラム. キーワード引数と多重ディスパッチ

# #### コード5-a. キーワード引数と多重ディスパッチ

fn(x, y; z=0.0) = x + y + z

fn(x, y; u="") = "$(x + y)" * u

fn(1, 2, u="kg")

fn(1, 2, z=3.0)

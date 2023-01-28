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

# ## 4-5. ユーザ定義型

# ### 4-5-1. ユーザによる型の定義

# #### コード4-12. 型定義の例 (1)（再掲）

struct Decimal <: Real
    value::BigInt
    point::Int
end

# #### コード4-46. 型定義の例 (3)：抽象型の定義例

abstract type AbstractQDInfo end

abstract type AbstractQDError <: AbstractQDInfo end

abstract type AbstractData{T} end

abstract type AbstractPoint{T<:Real} end

# #### コード4-47. 型定義の例 (4)：構造体の定義例

struct Decimal <: Real
    value::BigInt
    point::Int
end

struct Point2D{T} <: AbstractPoint{T}
    x::T
    y::T
end

struct MyIntegerArray{T<:Integer, N} <: AbstractArray{T, N}
    inner::Array{T, N}
end

struct MySingleton end

# #### コード4-48. 型定義の例 (5)：可変構造体の定義例

# このまま実行すると後ほど「invalid redefinition of constant Future」というエラーが出てしまうのでコメントアウト
#=
mutable struct Future
    value
    done::Bool
end
=#

mutable struct MPoint2D{T} <: AbstractPoint{T}
    x::T
    y::T
end

# #### コード4-49. 構造体と可変構造体の違い確認例

mpt = MPoint2D(0, 0)

mpt.x = 1;
mpt.y = 2;
mpt

pt = Point2D(0, 0)

pt.x = 1

# #### コード4-50. 型定義の例 (6)：プリミティブ型の定義例

primitive type Int24 <: Signed 24 end

primitive type Address{T} 64 end

# ### 4-5-2. コンストラクタ定義

# #### コード4-51. `Point2D{T}` 型の定義例

struct Point2D{T} <: AbstractPoint{T}
    x::T
    y::T
end

pt = Point2D(1, 2)

pt.x

pt.y

# #### コード4-52. `MPoint2D{T}` 型とその外部コンストラクタの定義例

mutable struct MPoint2D{T} <: AbstractPoint{T}
    x::T
    y::T
end

function MPoint2D(v)
    MPoint2D(v, v)
end

function MPoint2D()
    MPoint2D(0.0)
end

function MPoint2D{T}() where T<:Real
    MPoint2D(zero(T))
end

# #### コード4-53. `MPoint2D{T}` 型のインスタンス生成例

MPoint2D(1, 2)

MPoint2D(1)

MPoint2D()

MPoint2D{Int}()

# #### コード4-54. `Future` 型とその内部コンストラクタの定義例

mutable struct Future
    value
    done::Bool

    function Future()
        object = new()
        object.done = false
        object
    end
    function Future(value)
        new(value, true)
    end
end

# #### コード4-55. `Future` 型のインスタンス生成例

f0 = Future()

f1 = Future("Concrete Value")

f2 = Future("Concrete Value", true)

# #### コード4-56. 加工・変換のための外部コンストラクタの例 (1)

function Point2D(t::NTuple{2, T}) where T<:Real
    Point2D(t...)
end

function MPoint2D(t::NTuple{2, T}) where T<:Real
    MPoint2D(t...)
end

function Point2D(mpt::MPoint2D)
    Point2D(mpt.x, mpt.y)
end

function MPoint2D(pt::Point2D)
    MPoint2D(pt.x, pt.y)
end

# #### コード4-57. 加工・変換のための外部コンストラクタの例 (2)

t1 = (1, 2)

pt1 = Point2D(t1)

mpt1 = MPoint2D(t1)

Point2D(mpt1)

MPoint2D(pt1)

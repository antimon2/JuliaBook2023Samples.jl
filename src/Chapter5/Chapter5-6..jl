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

# ## 5-6. Holy トレイト

# ### 5-6-1. Holy トレイトとは？

# #### コード5-38. トレイト型の定義例（`ToTupleStyle`）

abstract type ToTupleStyle end

struct IsAlreadyTuple <: ToTupleStyle end

struct IsScalar <: ToTupleStyle end

struct Splattable <: ToTupleStyle end

# #### コード5-39. Holy トレイトによる関数の多重定義例（`tupleit()`）

tupleit(v) = tupleit(ToTupleStyle(v), v)

tupleit(::IsAlreadyTuple, t) = t

tupleit(::IsScalar, v) = (v,)

tupleit(::Splattable, xs) = (xs...,)

# #### コード5-40. `ToTupleStyle()` の定義と `tupleit()` の動作例 (1)

ToTupleStyle(::Tuple) = IsAlreadyTuple()

ToTupleStyle(::Number) = IsScalar()

ToTupleStyle(::AbstractArray) = Splattable()

ToTupleStyle(::AbstractString) = IsScalar()
# 文字列は展開可能だが「単一の値」として扱った方が妥当

tupleit((1, :a, '😁'))  # タプルを渡したらそのままタプルを返す

tupleit(99.9)  # 数値（スカラー値）を渡したらその値だけからなる要素数1のタプルを返す

tupleit([3, 1, 4, 1, 6])  # 配列を渡したらその各値からなるタプルを返す

tupleit(1:5)  # 範囲オブジェクトは AbstractVector の派生型なので

tupleit([])  # 空の配列なら空のタプルに

tupleit("123ABCあいう漢字😁")  # 文字列ならそれだけを単一の値として持つタプルに

# #### コード5-41. `ToTupleStyle()` の定義と `tupleit()` の動作例 (2)

ToTupleStyle(::Any) = IsScalar()  # デフォルトは IsScalar（単一の値）の扱いとする

ToTupleStyle(::NamedTuple) = Splattable()  # NamedTuple は展開可能

ToTupleStyle(::AbstractSet) = Splattable()  # 集合も展開可能

ToTupleStyle(::Ref) = Splattable()  # Ref は展開可能（参照している単一の値が列挙される）

tupleit() = ()  # 引数が空 ⇒ 空のタプル

tupleit(x, xs...) = (tupleit(x)..., tupleit(xs...)...)
# 引数が2つ以上 ⇒ 再帰呼び出しでそれぞれの要素を `tupleit()`

tupleit((a=1, b=:b, c='😁'))  # `NamedTuple`

tupleit(Set([3, 1, 4, 1, 5, 9, 2, 6, 5, 3]))  # `Set`

tupleit(Dict(:a => 1, :b => 2))
# 辞書（`Dict`）は展開可能だが、各要素が `:key => ○` のようなペアになるので
# 単一の値として扱うようにする

tupleit(Ref([1, 5, 3]))
# `Ref` で括ることによって `Splattable` な値もそのまま 
# Scalar のように扱われるようにした

tupleit(1, (1, :a, '😁'), 1:5, Ref([3, 1, 4, 1, 6]))  # 複数引数

# ### 5-6-2. 実例：`IndexStyle`

# #### コード5-42. `IndexStyle()` の例 (1)（`IndexCartesian` トレイト）

struct SampleSimpleArray{N} <: AbstractArray{NTuple{N, Int}, N}
    size::NTuple{N, Int}
end

IndexStyle(SampleSimpleArray)

# #### コード5-43. `IndexCartesian` トレイトの場合のインデクシングの例

Base.size(a::SampleSimpleArray) = a.size

function Base.getindex(a::SampleSimpleArray{N}, idxs::Vararg{Int, N}) where N
    idxs
end

ssa = SampleSimpleArray((3, 4));

ssa[1, 1]

ssa[2, 3]

collect(ssa)

eachindex(ssa)

# #### コード5-44. `IndexCartesian` トレイトの場合の線形インデックスの例

ssa[1]  # 参考：`fldmod1(1, 3) == (1, 1)`

ssa[8]  # 参考：`fldmod1(8, 3) == (3, 2)`

ssa[1:12]

# #### コード5-45. `IndexStyle` を指定した `eachindex()` の実行例

eachindex(IndexCartesian(), ssa)  # ＝ `eachindex(ssa)`

eachindex(IndexLinear(), ssa)

[ssa[i] for i in eachindex(IndexLinear(), ssa)]  # 実質 `ssa[1:12]` と同じ

# #### コード5-46. `IndexStyle()` の例 (2)（`IndexLinear` トレイト）

struct SampleLinearArray{N} <: AbstractArray{Int, N}
    size::NTuple{N, Int}
end

Base.IndexStyle(::Type{<:SampleLinearArray}) = IndexLinear()

IndexStyle(SampleLinearArray)

Base.size(a::SampleLinearArray) = a.size

function Base.getindex(a::SampleLinearArray, idx::Int)
    idx
end

# #### コード5-47. `IndexLinear` トレイトの場合のインデクシングの例

sla = SampleLinearArray((3, 4));

sla[1]

sla[8]

collect(sla)

eachindex(sla)

# #### コード5-48. `IndexLinear` トレイトの場合の直積インデックスの例

sla[1, 1]  # 参考：`(1 - 1) * 3 + 1 == 1`

sla[2, 3]  # 参考：`(3 - 1) * 3 + 2 == 8`

eachindex(IndexLinear(), sla)  # ＝ `eachindex(sla)`

eachindex(IndexCartesian(), sla)

[sla[i] for i in eachindex(IndexCartesian(), sla)]  # 実質 `collect(sla)` と同じ

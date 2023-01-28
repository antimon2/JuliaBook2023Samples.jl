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

# ## 6-2. イテレーションプロトコルの実装

# ### 6-2-1. サイズが決まっているパターン

# #### 例1. 配列（`AbstractArray`）の派生型とする場合（推奨）

# ##### コード6-19. `GeometricArray`（多次元に対応した等比数列型）

# ```julia
# struct GeometricArray{T<:Number, N} <: AbstractArray{T, N}
#     a::T
#     r::T
#     ns::NTuple{N, Int}
# end
#
# function GeometricArray(a::T1, r::T2, ns::NTuple{N, Integer}) where {T1, T2, N}
#     GeometricArray(promote(a, r)..., Int.(ns))
# end
#
# function Base.show(io::IO, box::GeometricArray)
#     print(io, "GeometricArray(", box.a, ", ", box.r, ", ", box.ns, ")")
# end
# Base.show(io::IO, ::MIME"text/plain", box::GeometricArray) = show(io, box)
#
# # Base.IteratorSize(GeometricArray{Int, 3}) == Base.HasShape{3}()
#
# Base.size(box::GeometricArray) = box.ns
# # `Base.length()` はデフォルト実装を利用
#
# # Base.IteratorEltype(GeometricArray) == Base.HasEltype()
# # eltype(GeometricArray{Int, 3}) == Int
#
# Base.IndexStyle(::Type{<:GeometricArray}) = IndexLinear()
# @inline function Base.getindex(box::GeometricArray, idx::Int) where {T, N}
#     @boundscheck checkbounds(box, idx::Int)
#     box.a * box.r ^ (idx - 1)
# end
# ```

include("GeometricArray.jl")

# ##### コード6-20. `GeometricArray` の動作確認

garray3 = GeometricArray(10, 0.5, (5, 4, 3))

Base.IteratorSize(typeof(garray3))  # GeometricArray <: AbstractArray なので `HasShape{N}`

size(garray3)

length(garray3)

Base.IteratorEltype(typeof(garray3))  # GeometricArray <: AbstractArray なので `HasEleType`

Base.eltype(garray3)

for v in garray3
    println(v)
end

[v for v in garray3]

collect(garray3)

# #### 例2. 配列（`AbstractArray`）の派生型としない場合

# ##### コード6-21. `GeometricBox`（多次元に対応した等比数列型（配列型の派生型としない実装））

# ```julia
# struct GeometricBox{T<:Number, N}
#     a::T
#     r::T
#     ns::NTuple{N, Int}
# end
#
# function GeometricBox(a::T1, r::T2, ns::NTuple{N, Integer}) where {T1, T2, N}
#     GeometricBox(promote(a, r)..., Int.(ns))
# end
#
# #### `IteratorSize()`
# Base.IteratorSize(::Type{GeometricBox{T, N}}) where {T, N} = Base.HasShape{N}()
# Base.size(box::GeometricBox) = box.ns
# Base.length(box::GeometricBox) = prod(box.ns)
#
# #### `IteratorEltype()`
# # Base.IteratorEltype(::Type{<:GeometricBox}) = Base.HasEltype()
# Base.eltype(::Type{<:GeometricBox{T}}) where {T} = T
#
# #### `iterate()`
# Base.iterate(box::GeometricBox) = (box.a, (box.a, length(box) - 1))
# function Base.iterate(box::GeometricBox{T}, (prev, rest)::Tuple{T, Int}) where {T}
#     rest == 0 && return nothing
#     next = prev * box.r
#     (next, (next, rest - 1))
# end
# ```

include("GeometricBox.jl")

# ##### コード6-22. `GeometricBox` の動作確認

gbox3 = GeometricBox(10, 0.5, (5, 4, 3))

Base.IteratorSize(typeof(gbox3))

size(gbox3)

length(gbox3)

Base.IteratorEltype(typeof(gbox3))

Base.eltype(gbox3)

for v in gbox3
    println(v)
end

[v for v in gbox3]

collect(gbox3)

# ### 6-2-2. 長さが不定のパターン

# #### 例. コラッツの予想

# ##### コード6-23. Collatz（コラッツの予想をイテレーションで実現する例）

# ```julia
# struct Collatz{I <: Integer}
#     start::I
# end
#
# Base.IteratorSize(::Type{<:Collatz}) = Base.SizeUnknown()
#
# Base.IteratorEltype(::Type{<:Collatz}) = Base.HasEltype()
# Base.eltype(::Type{Collatz{I}}) where I = I
#
# Base.iterate(c::Collatz) = (c.start, c.start)
# function Base.iterate(::Collatz, prev)
#     prev == 1 && return nothing
#     next = if iseven(prev)
#         prev ÷ 2
#     else
#         3prev + 1
#     end
#     (next, next)
# end
# ```

include("Collatz.jl");

# ##### コード6-24. コラッツの予想（長さが有限のものの確認）

for n in Collatz(3)
    println(n)
end

collect(Collatz(27))

maximum(Collatz(27))

# ##### コード6-25. コラッツの予想（初期値が負数のもの）

# Do not execute below:
#
# ```julia
# julia> for n in Collatz(-3)
#            println(n)
#        end
# -3
# -8
# -4
# -2
# -1
# -2
# -1
# -2
# -1
# -2
# -1
# -2
# -1
#  : 《以下延々と繰り返し…》
# ```

# collect(Collatz(-3))  # ←実行してはいけません！
collect(Iterators.take(Collatz(-3), 20))

# ### 6-2-3. 無限列挙

# #### 例. フィボナッチ数列

# ##### コード6-26. フィボナッチ数列

# ```julia
# struct FibSequence end
# const Fib = FibSequence()
#
# Base.IteratorSize(::Type{FibSequence}) = Base.IsInfinite()
#
# # Base.IteratorEltype(::Type{FibSequence}) = Base.HasEltype()
# Base.eltype(::Type{FibSequence}) = BigInt
#
# Base.iterate(::FibSequence) = iterate(Fib, (big"1", big"0"))
#
# function Base.iterate(::FibSequence, (Fₙ₋₂, Fₙ₋₁)::NTuple{2, BigInt})
#     Fₙ = Fₙ₋₂ + Fₙ₋₁
#     (Fₙ, (Fₙ₋₁, Fₙ))
# end
# ```

include("FibSequence.jl");

# ##### コード6-27. フィボナッチ数列の動作確認

for n in Iterators.take(Fib, 10)
    println(n)
end

collect(Iterators.take(Fib, 20))

first(Iterators.drop(Fib, 99))  # the 100th number

collect(Fib)  # `Base.IsInfinite()` ならばエラーとなる

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

# ## 7-3. ブロードキャスティングの適用

# ### 実例(1) 配列の派生型

# #### コード7-23. `GeometricSequence.jl`（1～18行目、コード6-3(1). 再掲）

# ```julia
# struct GeometricSequence{T<:Number} <: AbstractVector{T}
#     a::T
#     r::T
#     n::Int
# end
#
# function GeometricSequence(a::T1, r::T2, n::Integer) where {T1<:Number, T2<:Number}
#     GeometricSequence(promote(a, r)..., Int(n))
# end
#
# Base.length(seq::GeometricSequence) = seq.n
# Base.size(seq::GeometricSequence) = (seq.n,)
# Base.getindex(seq::GeometricSequence, index::Integer) = seq.a * seq.r ^ (index - 1)
#
# function Base.show(io::IO, seq::GeometricSequence)
#     print(io, "GeometricSequence(", seq.a, ", ", seq.r, ", ", seq.n, ")")
# end
# Base.show(io::IO, ::MIME"text/plain", seq::GeometricSequence) = show(io, seq)
# ```

include("GeometricSequence.jl")

# #### コード7-24. `GeometricSequence` のブロードキャスティング適用確認

seq0 = GeometricSequence(1, 3, 8)

seq0 isa AbstractVector

Broadcast.broadcastable(seq0)  # return `seq0` itself

Broadcast.BroadcastStyle(typeof(seq0))

log.(seq0)

seq0 .+ 1  # same as [v + 1 for v in seq0]

[1.0 3.0^8] .* seq0

# ### 実例(2) イテレーションプロトコルを実装した型

# #### コード7-25. `Collatz.jl`（コード6-22. 再掲）

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

include("Collatz.jl")

# #### コード7-26. `Collatz` のブロードキャスティング適用確認

c3 = Collatz(3)

c3 isa AbstractArray

Broadcast.broadcastable(c3)  # equivalent to `collect(c3)`

Broadcast.BroadcastStyle(typeof(Broadcast.broadcastable(c3)))

seq0 = GeometricSequence(1, 3, 8);

.-c3

max.(c3, seq0)

c3 .+ seq0

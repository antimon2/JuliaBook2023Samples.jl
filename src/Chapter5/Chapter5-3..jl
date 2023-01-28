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

# ## 5-3. ポリモーフィズム

# ### 5-3-1. Julia のポリモーフィズム

# #### コード5-17.	アドホック多相の例（「鳴く」のポリモーフィズムを Julia のコードで再現）

struct 犬 end

struct ネコ end

struct ミンミンゼミ end

鳴く(::犬) = "ワン"

鳴く(::ネコ) = "ニャー"

鳴く(::ミンミンゼミ) = "ミーンミーン"

鳴く(犬())

鳴く(ネコ())

鳴く(ミンミンゼミ())

# #### コード5-18.	パラメータ多相の例 (1): 定義例（`predtypes()`）

function predtypes(x::Int, y::Int)
    "Both $x and $y are `Int`."
end

function predtypes(x::T, y::T) where T
    "Both $x and $y are the same types ($T)."
end

function predtypes(x::N, y::N) where {N <: Number}
    "Both $x and $y are the same Number types ($N)."
end

function predtypes(x::T1, y::T2) where {T1, T2}
    "$x(::$T1) and $y(::$T2) are diffrent types."
end

# #### コード5-19.	パラメータ多相の例 (2): 実行例（`predtypes()` の動作確認）

Base.typesof(1, 2)

predtypes(1, 2)

Base.typesof("abc", "漢字")

predtypes("abc", "漢字")

Base.typesof(:ok, :NG)

predtypes(:ok, :NG)

Base.typesof(1.0, 2.2)

predtypes(1.0, 2.2)

Base.typesof(1//2, 3//4)

predtypes(1//2, 3//4)

Base.typesof(1.0, π)

predtypes(1.0, π)

# ### 5-3-2. 実例

# #### コード5-20.	GeometricSequence.jl (1): `Base.show()` の多重定義まで

# +
struct GeometricSequence{T<:Number} <: AbstractVector{T}
    a::T
    r::T
    n::Int
end

function GeometricSequence(a::T1, r::T2, n::Integer) where {T1<:Number, T2<:Number}
    GeometricSequence(promote(a, r)..., Int(n))
end

Base.length(seq::GeometricSequence) = seq.n
Base.size(seq::GeometricSequence) = (seq.n,)
Base.getindex(seq::GeometricSequence, index::Integer) = seq.a * seq.r ^ (index - 1)

function Base.show(io::IO, seq::GeometricSequence)
    print(io, "GeometricSequence(", seq.a, ", ", seq.r, ", ", seq.n, ")")
end
Base.show(io::IO, ::MIME"text/plain", seq::GeometricSequence) = show(io, seq)
# -

# #### コード5-21.	`GeometricSequence` の動作確認 (1): 基本的な動作

seq0 = GeometricSequence(1, 3, 5)

length(seq0)

size(seq0)

collect(seq0)

sum(seq0)

# #### コード5-22. GeometricSequence.jl (2): Base.sum() の多重定義（ポリモーフィズム）

# +
function Base.sum(seq::GeometricSequence)
    seq.a * (1 - seq.r^seq.n) / (1 - seq.r)
end

function Base.sum(seq::GeometricSequence{<:Rational})
    c = numerator(seq.a)
    b = denominator(seq.a)
    q = numerator(seq.r)
    p = denominator(seq.r)
    n = seq.n
    c * (p^n - q^n) // (b * p^(n-1) * (p - q))
end

function Base.sum(seq::GeometricSequence{<:Integer})
    seq.a * ((seq.r^seq.n - 1) ÷ (seq.r - 1))
end
# -

# #### コード5-23.	`GeometricSequence` の動作確認 (2): `sum()` の動作

sum_naive(seq) = reduce(+, seq)

sum_with_formula(seq) = seq.a * (1 - seq.r^seq.n) / (1 - seq.r)

seq1 = GeometricSequence(1, 0.5, 20)

(sum_naive(seq1), sum(seq1))

using BenchmarkTools

@btime sum_naive($seq1)

@btime sum($seq1)

seq2 = GeometricSequence(1, 1//2, 20)

(sum_naive(seq2), sum_with_formula(seq2), sum(seq2))

@btime sum_naive($seq2)

@btime sum_with_formula($seq2)

@btime sum($seq2)

seq3 = GeometricSequence(1, 3, 20)

(sum_naive(seq3), sum_with_formula(seq3), sum(seq3), sum_naive(seq3) == sum_with_formula(seq3) == sum(seq3))

typeof.((sum_naive(seq3), sum_with_formula(seq3), sum(seq3)))

@btime sum_naive($seq3)

@btime sum_with_formula($seq3)

@btime sum($seq3)

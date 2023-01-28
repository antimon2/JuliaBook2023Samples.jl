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

# ## 6-1. イテレーションの仕組み

# ### 6-1-1. イテレーションも糖衣構文

# #### 仮想コード6-1. `for` 文の例

# ```julia
# for value in iter
#     println(value)
# end
# ```

# #### 仮想コード6-2. `for` 文と等価なコード例

# ```julia
# next = iterate(iter)
# while next !== nothing
#     value, state = next
#     println(value)
#     next = iterate(iter, state)
# end
# ```

# #### コード6-1. 仮想コード6-1./6-2. の動作確認

iter = [31, 41, 59, 26, 53];

for value in iter
    println(value)
end

# +
next = iterate(iter);

while next !== nothing
    value, state = next
    println(value)
    next = iterate(iter, state)
end
# -

# ### 6-1-2. `iterate()` 関数

# #### 仮想コード6-2. `for` 文と等価なコード例（再掲）

# ```julia
# next = iterate(iter)
# while next !== nothing
#     value, state = next
#     println(value)
#     next = iterate(iter, state)
# end
# ```

# #### 仮想コード6-3. `AbstractArray` の `iterate()` 関数の実装イメージ

# ```julia
# function Base.iterate(a::AbstractArray)
#     isempty(a) && return nothing
#     (a[1], 2)
# end
# function Base.iterate(a::AbstractArray, i)
#     i > length(a) && return nothing
#     (a[i], i + 1)
# end
# ```

# #### 仮想コード6-4. `AbstractString` の `iterate()` 関数の実装イメージ

# ```julia
# function Base.iterate(s::AbstractString)
#     isempty(a) && return nothing
#     (s[1], nextind(s, 1))
# end
# function Base.iterate(s::AbstractString, i)
#     i > ncodeunits(s) && return nothing
#     (s[i], nextind(s, i))
# end
# ```

# #### コード6-2. `iterate()` 関数の動作確認（配列、文字列）

iterate([31, 41, 59, 26, 53])

iterate([31, 41, 59, 26, 53], 2)

iterate([31, 41, 59, 26, 53], 5)

iterate([31, 41, 59, 26, 53], 6) === nothing

iterate("あいうえお")

iterate("あいうえお", 4)

iterate("あいうえお", 13)

iterate("あいうえお", 16) === nothing

# #### コード6-3(1). `GeometricSequence.jl`（1～18行目）

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

# #### コード6-3(2). `GeometricSequence.jl`（37～44行目）

function Base.iterate(seq::GeometricSequence)
    seq.n > 0 || return nothing
    (seq.a, (seq.a * seq.r, seq.n - 1))
end
function Base.iterate(seq::GeometricSequence, (next, count)::NTuple{2})
    count == 0 && return nothing
    (next, (next * seq.r, count - 1))
end

include("GeometricSequence.jl")

# #### コード6-4. `GeometricSequence` のイテレーション動作確認

seq0 = GeometricSequence(1, 3, 5);

for value in seq0
    println(value)
end

for i = 1:length(seq0)
    println(seq0[i])
end  # 参考：出力結果が同じになることの確認のため

seq1 = GeometricSequence(1, 0.5, 20);

@time for i = 1:length(seq1)
    println(devnull, seq1[i])
end

@time for value in seq1
    println(devnull, value)
end

# #### コード6-5. `GeometricSequence` の分割代入動作確認

seq0 = GeometricSequence(1, 3, 5);

x₁, x₂, x₃, x₄, x₅ = seq0

(x₁, x₂, x₃, x₄, x₅)

x₁, x₂, x₃ = seq0

(x₁, x₂, x₃)

x₁, x₂, x₃, x₄, x₅, x₆ = seq0  # エラー

struct NotIterable end
x₁, x₂, x₃ = NotIterable()  # エラー

# #### コード6-6. `GeometricSequence` の `in`演算子（`in()`関数） 動作確認

seq2 = GeometricSequence(2, 3, 20);

54 in seq2

486 ∈ seq2

888 ∉ seq2

seq2 ∋ 9565938

seq2 ∌ 2147483647

filter(in(seq2), 100:200)

# ### 6-1-3. `Base.IteratorSize` と `Base.IteratorEltype`

# #### コード6-7. `GeometricSequence` の内包表記および `collect()`関数 動作確認

[i for i in GeometricSequence(1, 3, 5)]

collect(GeometricSequence(1, 3, 5))

# #### コード6-8. 約数を列挙するイテレータの定義例（`Divisors1`）

struct Divisors1{I <: Integer}
    n::I
end

# +
Base.iterate(ds::Divisors1{I}) where {I} = (one(I), one(I))

function Base.iterate(ds::Divisors1{I}, next::I) where {I}
    while next < ds.n
        next += one(I)
        ds.n % next == 0 && return (next, next)
    end
    nothing
end
# -

# #### コード6-9. `Divisors1` の動作確認（`for`文）

ds1_36 = Divisors1(36)

for n in ds1_36
    println(n)
end

# #### コード6-10. `Divisors1` の動作確認（内包表記/`collect`関数、エラー例）

[n for n in ds1_36]

collect(ds1_36)

# #### `Base.IteratorSize`

# ##### コード6-11. `Divisors1` が `Base.SizeUnknown` トレイトを準拠するようにした場合の動作例

Base.IteratorSize(::Type{<:Divisors1}) = Base.SizeUnknown()

ds1_36 = Divisors1(36);

[n for n in ds1_36]

collect(ds1_36)

# ##### コード6-12. 約数を列挙するイテレータの定義例（`Divisors2`）

struct Divisors2{I <: Integer}
    n::I
end

Base.iterate(ds::Divisors2{I}) where {I} = (one(I), one(I))
function Base.iterate(ds::Divisors2{I}, next::I) where {I}
    while next < ds.n
        next += one(I)
        ds.n % next == 0 && return (next, next)
    end
    nothing
end

# +
# ↓デフォルトでこうなっているので明示的に多重定義せず
# Base.IteratorSize(::Type{<:Divisors2}) = Base.HasLength()

function Base.length(ds::Divisors2)
    n = ds.n
    sqrtn = isqrt(n)
    l = trailing_zeros(n) + 1
    n >>= l - 1
    p = oftype(n, 3)
    d = 2
    while p ≤ n && p ≤ sqrtn
        if n % p == 0
            cnt_1 = 1
            while n % p == 0
                n ÷= p
                cnt_1 += 1
            end
            l *= cnt_1
        end
        p += d
        d = 6 - d
    end
    n > 1 ? 2l : l
end
# -

# ##### コード6-13. `Divisors2` の動作例

ds2_36 = Divisors2(36)

Base.IteratorSize(typeof(ds2_36))

length(ds2_36)

for n in ds2_36
    println(n)
end

[n for n in ds2_36]

collect(ds2_36)

# ##### コード6-14. `Divisors1` と `Divisors2` のパフォーマンス比較その1（`Base.IteratorSize` の差異）

ds1_360 = Divisors1(360);
ds2_360 = Divisors2(360);

Base.IteratorSize(typeof(ds1_360))

Base.IteratorSize(typeof(ds2_360))

[n for n in ds1_360]

[n for n in ds2_360]

[n for n in ds1_360] == [n for n in ds2_360]

@time [n for n in ds1_360];

@time [n for n in ds2_360];

# #### `Base.IteratorEltype`

# ##### コード6-15. `Base.eltype()` を適切に定義した `Divisors1` および `Divisors2` の挙動確認

Base.eltype(::Type{Divisors1{I}}) where {I} = I
Base.eltype(::Type{Divisors2{I}}) where {I} = I

ds1_36 = Divisors1(36)

ds2_36 = Divisors2(36)

Base.IteratorEltype(typeof(ds1_36))

Base.eltype(ds1_36)

Base.IteratorEltype(typeof(ds2_36))

Base.eltype(ds2_36)

collect(ds1_36)

collect(ds2_36)

# #### コード6-16. `Divisors3` の定義（`Base.SizeUnknown`/`Base.EltypeUnknown`）

struct Divisors3{I <: Integer}
    n::I
end

Base.iterate(ds::Divisors3{I}) where {I} = (one(I), one(I))
function Base.iterate(ds::Divisors3{I}, next::I) where {I}
    while next < ds.n
        next += one(I)
        ds.n % next == 0 && return (next, next)
    end
    nothing
end

Base.IteratorSize(::Type{<:Divisors3}) = Base.SizeUnknown()

Base.IteratorEltype(::Type{<:Divisors3}) = Base.EltypeUnknown()

# ##### コード6-17. `Divisors3` の挙動確認

ds3_36 = Divisors3(36)

[n for n in ds3_36]

collect(ds3_36)

# ##### コード6-18. `Divisors1` と `Divisors3` のパフォーマンス比較（`Base.IteratorEltype` の差異による比較）

ds1_360 = Divisors1(360);
ds3_360 = Divisors3(360);

Base.IteratorEltype(typeof(ds1_360))

Base.eltype(ds1_36)

Base.IteratorEltype(typeof(ds3_360))

collect(ds1_360)

collect(ds3_360)

collect(ds1_360) == collect(ds3_360)

@time collect(ds1_360);

@time collect(ds3_360);

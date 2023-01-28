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

# ## 5-7. その他の実用例

# ### 5-7-1. `sort()` のアルゴリズム指定

# #### コード5-49.	ソートアルゴリズムの実装例（バイトニックソート）

# +
module BitonicSorterST

# ref: https://en.wikipedia.org/wiki/Bitonic_sorter

export BitonicSort

using Base.Order: Ordering, lt

struct BitonicSortAlg <: Base.Sort.Algorithm end
const BitonicSort = BitonicSortAlg()

function Base.sort!(x::AbstractVector, lo::Integer, hi::Integer, ::BitonicSortAlg, o::Ordering)
    lo ≥ hi && return x

    fullsize::Int = hi - lo
    d = sizeof(Int) * 8 - leading_zeros(fullsize - 1)  # == ceil(Int, log(2, fullsize))

    for p = 1:d, q = 1:p
        _sort_kernel!(x, lo, hi, p, q, o)
    end
    return x
end

function _sort_kernel!(x::AbstractVector, lo, hi, p, q, o)
    # @assert p ≥ q
    halfsize_1 = Int(hi - lo) >> 0x01
    d = 1 << UInt(p - q)
    for s = 0:halfsize_1
        ioff = s & (d - 1)
        seg = lo + (s ⊻ ioff) << 0x01
        joff = q == 1 ? (2d - ioff - 1) : ioff + d
        i = seg + ioff
        j = seg + joff
        if !lt(o, x[i], x[j])
            x[i], x[j] = x[j], x[i]
        end
    end
end

end # module
# -

# #### コード5-50.	`BitonicSort` の動作例

using .BitonicSorterST

x_org = [10, 30, 11, 20, 4, 330, 21, 110];

sort(x_org)  # デフォルトのソートアルゴリズムでソート

sort(x_org; alg=BitonicSort)  # BitonicSortでソート

sort(x_org; alg=BitonicSort, lt=(>))  # BitonicSortで逆順ソート

strs_org = ["Julia", "is", "fast", "dynamiccaly", "typed", "with", "multiple", "dispatch"];

sort(strs_org; alg=BitonicSort)

check_sorted = sort!(rand(Float64, 2^16); alg=BitonicSort);

issorted(check_sorted)

# ### 5-7-2. `Val{N}` によるディスパッチ

# #### 仮想コード5-4. `ntuple(f, Val{N})` の実装例

# ```julia
# # ntuple の実装例（抜粋、一部改変）
# ntuple(f, ::Val{0}) = ()
# ntuple(f, ::Val{1}) = (f(1),)
# ntuple(f, ::Val{2}) = (f(1), f(2))
# ntuple(f, ::Val{3}) = (f(1), f(2), f(3))
# function ntuple(f::F, ::Val{N}) where {F,N}
#     N::Int
#     (N >= 0) || throw(ArgumentError(string("tuple length should be ≥ 0, got ", N)))
#     ((f(i) for i = 1:N)...,)
# end
# ```

# #### コード5-51. 色々な国の挨拶を返す関数 `hello()` の例

hello(lang::Symbol = :en) = hello(Val(lang))

hello(::Val{:en}) = println("Hello!")

hello(::Val{:ja}) = println("こんにちは！")

hello(::Val{:zh}) = println("你好!")

hello(::Val{:ko}) = println("안녕하세요!")

hello(::Val{:fr}) = println("Bonjour!")

hello(::Val{:it}) = println("Ciao!")

hello(::Val{:po}) = println("Olá!")

function hello(::Val{lang}) where {lang}
    println("Sorry but I'm not familiar with your language ($lang).")
    println("Tell me the greeting of your native.")
end

hello()

hello(:ja)

hello(:it)

hello(:th)

hello(::Val{:th}) = println("สวัสดี!")

hello(:th)

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

# ## 8-6. 生成関数

# ### 8-6-1. 生成関数 (Generated Function) とは

# #### コード8-46. 簡単な生成関数の例（`printwithtype()`）

@generated function printwithtype(x)
    :(print(x, " is a type of ", $x))
end

# #### コード8-47. `printwithtype()` 関数の動作確認

printwithtype(1)

printwithtype("文字列")

printwithtype(rand())

printwithtype(Int)

@code_lowered printwithtype(1)

# #### コード8-48. 生成関数の例(2)（`grand1to10()`）

@generated function grand1to10(_DUMMY...)
    rand(1:10)
end

grand1to10()

grand1to10()

grand1to10()

grand1to10(3)

grand1to10(5)

grand1to10(123)

grand1to10(Int, "123")

grand1to10(Int, "他の文字列")

# #### コード8-49. 生成関数の例(3)（`gpredtypes()`）

@generated function gpredtypes(x, y)
    if x !== y
        :("$x(::$($x)) and $y(::$($y)) are diffrent types.")
    elseif x === Int
        :("Both $x and $y are `Int`.")
    elseif x <: Number
        :("Both $x and $y are the same Number types ($($x)).")
    else
        :("Both $x and $y are the same types ($($x)).")
    end
end

gpredtypes(1, 2)

gpredtypes("abc", "漢字")

gpredtypes(:ok, :NG)

gpredtypes(1.0, 2.2)

gpredtypes(1//2, 3//4)

gpredtypes(1.0, π)

# ### 8-6-2. 生成関数の特徴と注意点

# #### コード8-50. 生成関数のNG例(1)

_double_impl(::Type{<:AbstractString}) = :(a^2)

@generated gdouble(a) = _double_impl(a)

_double_impl(::Type{<:Number}) = :(2a)

gdouble("a")

gdouble(2)

# #### コード8-51. 生成関数のNG例(2)

isiterable(::Type{T}) where {T} = hasmethod(iterate, Tuple{T})

@generated function checkanditerate(itr)
    if isiterable(itr)
        quote
            for v in itr
                println(v)
            end
        end
    end
end

checkanditerate([1, 2, 3])

struct WrapArray{T <: AbstractArray}
    arr::T
end

a = WrapArray([1, 2, 3])

checkanditerate(a)  # 何も実行されない（正確には `nohitng` が評価されるのみ）

Base.iterate(a::WrapArray, st...) = iterate(a.arr, st...)  # 後で `iterate()` を実装

for v in a
    println(v)
end

checkanditerate(a)  # やっぱり何も実行されない

# ### 8-6-3. 実例

# #### 仮想コード8-5. `bdot()` 関数（仕様）

# ```julia
# julia> x = Float32[1, 2, 3];
#
# julia> v = [2, 3, 1];
#
# julia> bdot(v, x)  # == `dot(v, x)` と同等（`dot()` は要 `using LinearAlgebra`）
# 11.0f0
#
# julia> A = [1 4 7; 2 5 8; 3 6 9]
# 3×3 Matrix{Int64}:
#  1  4  7
#  2  5  8
#  3  6  9
#
# julia> bdot(A, x)  # [col' * x for col in eachcol(A)]  相当
# 3-element Vector{Float32}:
#  14.0
#  32.0
#  50.0
#
# julia> A3 = reshape(1:24, (3, 4, 2))
# 3×4×2 reshape(::UnitRange{Int64}, 3, 4, 2) with eltype Int64:
# [:, :, 1] =
#  1  4  7  10
#  2  5  8  11
#  3  6  9  12
#
# [:, :, 2] =
#  13  16  19  22
#  14  17  20  23
#  15  18  21  24
#
# julia> bdot(A3, x)
# 4×2 Matrix{Float32}:
#  14.0   86.0
#  32.0  104.0
#  50.0  122.0
#  68.0  140.0
#
# julia> # 以下、4次元以上の多次元配列でも同様
# ```

# #### コード8-52. `bdot()` 関数相当のコード（挙動の確認）

x = Float32[1, 2, 3]

v = 1:3

v' * x  # == `dot(v, x)`（ただし要 `using LinearAlgebra`）

A = reshape(1:6, (3, 2))

A' * x

y = zeros(Float32, 2);

for j = 1:2
    for i = 1:3
        y[j] += A[i, j] * x[i]
    end
end

y  # == A' * x

A3 = reshape(1:12, (3, 2, 2));
B = zeros(Float32, (2, 2));

for i_3 in axes(A3, 3)
    for i_2 in axes(A3, 2)
        for i_1 in axes(A3, 1)
            B[i_2, i_3] += A3[i_1, i_2, i_3] * x[i_1]
        end
    end
end

B

# #### コード8-53. `bdot()` 関数の実装

bdot(A::AbstractVecOrMat, x::AbstractVector) = A' * x

@generated function bdot(A::AbstractArray{T1, N}, x::AbstractVector{T2}) where {T1, T2, N}
    T = promote_type(T1, T2)
    idxs = ntuple(d->Symbol("i_", d), Val(N))
    ex = :(y[$(idxs[2:end]...)] += A[$(idxs...)] * x[$(idxs[1])])
    for d = 1:N
        ex = :(for $(idxs[d]) in axes(A, $d)
            $ex
        end)
    end
    quote
        y = zeros($T, size(A)[2:$N])
        $ex
        y
    end
end

# #### コード8-54. `bdot()` 関数の動作確認

x = Float32[1, 2, 3];

v = 1:3;
bdot(v, x)  # == v' * x

A = reshape(1:6, (3, 2));
bdot(A, x)  # == A' * x

A3 = reshape(1:12, (3, 2, 2));
bdot(A3, x)

A4 = reshape(1:24, (3, 2, 2, 2));
bdot(A4, x)

# #### コード8-55. `bdot()` の生成する引用表現の確認

function bdot_impl(::AbstractArray{T1, N}, ::AbstractVector{T2}) where {T1, T2, N}
    T = promote_type(T1, T2)
    idxs = ntuple(d->Symbol("i_", d), Val(N))
    ex = :(y[$(idxs[2:end]...)] += A[$(idxs...)] * x[$(idxs[1])])
    for d = 1:N
        ex = :(for $(idxs[d]) in axes(A, $d)
            $ex
        end)
    end
    quote
        y = zeros($T, size(A)[2:$N])
        $ex
        y
    end
end

bdot_impl(A, x) |> Base.remove_linenums!  # `A isa AbstractArray{Int, 2}`

bdot_impl(A3, x) |> Base.remove_linenums!  # `A3 isa AbstractArray{Int, 3}

bdot_impl(A4, x) |> Base.remove_linenums!  # `A4 isa AbstractArray{Int, 4}

# +
# 以下略
# -

# #### コード8-56. `bdot()` の他の実装方法とパフォーマンス比較

bdot2(A::AbstractVecOrMat, x::AbstractVector) = A' * x

bdot2(A::AbstractArray, x::AbstractVector) =
    [sum(A[i, j] * x[i] for i in axes(A, 1))
     for j in CartesianIndices(axes(A)[2:end])]

bdot3(A::AbstractVecOrMat, x::AbstractVector) = A' * x

bdot3(A::AbstractArray, x::AbstractVector) = 
    reshape(sum(A .* x, dims=1), size(A)[2:end])

bdot(v, x) == bdot2(v, x) == bdot3(v, x)

bdot(A, x) == bdot2(A, x) == bdot3(A, x)

bdot(A3, x) == bdot2(A3, x) == bdot3(A3, x)

bdot(A4, x) == bdot2(A4, x) == bdot3(A4, x)

A5 = reshape(1:48, (3, 2, 2, 2, 2));

bdot(A5, x) == bdot2(A5, x) == bdot3(A5, x)

@time bdot(A5, x);

@time bdot2(A5, x);

@time bdot3(A5, x);

using BenchmarkTools

@btime bdot($A5, $x);

@btime bdot2($A5, $x);

@btime bdot3($A5, $x);

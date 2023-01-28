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

# ## 4-4. 型制約

# ### 4-4-1. 型制約とは

# #### コード4-36. `where ○○` の例 (1)：`LinearIndices` の基本型

supertype(LinearIndices)

# #### コード4-37. `where ○○` の例 (2)：`Vector` 型

Vector

# #### コード4-38. `Complex` 型のヘルプ確認（再）

#=
?Complex
=#

# #### コード4-39. 型制約とパラメトリックサブタイピング

(Complex{T} where T<:Integer) <: Complex

(Array{T, 1} where T<:Integer) <: (Array{T, 1} where T)

# #### コード4-40. 制約無しの型制約の例

Array{T} where T

Array{T, N} where {T, N}

Array{T, N} where N where T

Array{Float64}

Vector

# ### 4-4-3. 型制約とサブタイピング

# #### コード4-41. 上界の型制約の例 (1)

Array{T} where T<:Real

# #### コード4-42. 上界の型制約の例 (2)：性質の確認

isabstracttype(Array{T} where T<:Real)

isconcretetype(Array{T} where T<:Real)

typeof(Array{T} where T<:Real)

# #### コード4-43. 上界の型制約の例 (3)：サブタイピング(1)

(Array{T, 1} where T<:Real) <: (Array{T} where T<:Real)

Array{Int} <: (Array{T} where T<:Real)

Array{Float64} <: (Array{T} where T<:Real)

[1, 2, 3] isa (Array{T} where T<:Real)

[1, 2.3, 4//5] isa (Array{T} where T<:Real)

[1+im, 2, 3] isa (Array{T} where T<:Real)

# #### コード4-44. 下界・上下界の型制約の例（サブタイピング）

(Array{T} where T>:Int) <: Array

(Array{T, 1} where T>:Int) <: (Array{T} where T>:Int)

Array{Int} <: (Array{T} where T>:Int)

Array{Real} <: (Array{T} where T>:Int)

Array{Real} <: (Array{T} where T>:Float64)

(Array{T} where Int<:T<:Number) <: Array

(Array{T, 1} where Int<:T<:Number) <: (Array{T} where Int<:T<:Number)

Array{Int} <: (Array{T} where Int<:T<:Number)

Array{Real} <: (Array{T} where Int<:T<:Number)

(Array{T, 1} where Int<:T<:Number) <: (Array{T} where T<:Number)

# #### コード4-45. 上界と下界の型制約の例（型変数の省略）

Complex{<:Integer} == (Complex{T} where T<:Integer)

Complex{>:Int} == (Complex{T} where T>:Int)

Complex{Int} <: Complex{<:Integer}

Complex{Int} <: Complex{>:Int}

1 + im isa Complex{<:Integer}

1 + im isa Complex{>:Int}

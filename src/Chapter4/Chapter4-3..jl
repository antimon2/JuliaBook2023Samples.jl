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

# ## 4-3. パラメトリック型

# ### 4-3-1. パラメトリック型

# #### コード4-21. `Complex` 型の性質確認例 (1)

isabstracttype(Complex)

isconcretetype(Complex)

# #### コード4-22. `Complex` 型の性質確認例 (2)

typeof(im)

typeof(1 + im)

typeof(2.0 + 3.0im)

# #### コード4-23. `Complex` 型のヘルプ確認

#=
?Complex
=#

# #### コード4-24. `Complex` 型の性質確認例 (3)

isconcretetype(typeof(1+im))

isconcretetype(Complex{Int64})

isconcretetype(typeof(2.0 + 3.0im))

isconcretetype(Complex{Float64})

# #### コード4-25. いくつかのパラメトリック型の例

typeof(Set(n^4%5 for n=1:5))

typeof(Dict(:a=>1, :b=>3, :d=>9))

typeof(2//3)

# ### 4-3-2. 型パラメータに指定出来るもの

# #### コード4-26. 配列型（の型パラメータ）の確認

typeof([1., 2., 3.])

typeof([1. 2.; 3. 4.])

typeof(zeros((2, 2, 2)))

# #### コード4-27. 型パラメータに指定できるものの確認例

struct ParamTypeSample{T} end

ParamTypeSample{Int}

ParamTypeSample{:yes}

ParamTypeSample{1}

ParamTypeSample{+}

ParamTypeSample{(1,:a,+)}

ParamTypeSample{1+im}

ParamTypeSample{"ABC"}

ParamTypeSample{[1,2,3]}

ParamTypeSample{340282366920938463463374607431768211456}

# ### 4-3-3. パラメトリック型のサブタイピング

# #### コード4-28. `Complex{Float64}` の基本型と `Complex` の派生型の確認例

Complex{Float64} <: Complex

Complex{Float64} >: Complex

supertype(Complex{Float64})

subtypes(Complex)

# #### コード4-29. 型パラメータと基本型-派生型の関係性の確認例 (1)

Complex{Float64} <: Complex{Float64}

Complex{Float64} >: Complex{Float64}

Complex{Float64} <: Complex{Int64}

Complex{Float64} >: Complex{Int64}

# #### コード4-30. パラメトリック型のサブタイピング確認例（配列型の例）

Array{Float64} <: Array

Array{Float64, 1} <: Array{Float64} <: Array

Array{Float64, 1} >: Array{Float64}

Array{Float64, 1} >: Array

all(A <: Array{Float64} for A in [
    Array{Float64, 1},
    Array{Float64, 2},
    Array{Float64, 3}])

Array{Float64, 1} <: Array{Float64, 2}

Array{Float64, 1} >: Array{Float64, 2}

Array{Int64, 1} <: Array{Float64}

Array{Int64, 1} <: Array{Float64, 1}

# #### コード4-31. 型パラメータと基本型-派生型の関係性の確認例 (2)

Int <: Integer

Array{Int} <: Array{Integer}

Int <: Any

Array{Int} <: Array{Any}

# ### 4-3-4. UnionAll型

# #### コード4-32. 型に対する `typeof()` 関数の適用例

typeof(Int)

typeof(Number)

typeof(Complex)

typeof(Complex{Float64})

typeof(Array)

typeof(Array{Float64})

typeof(Array{Float64,1})

# ### 4-3-5. パラメトリック抽象型

# #### コード4-33. 配列型の基本型（パラメトリック抽象型）の例 (1)

isabstracttype(Array)

typeof(Array)

supertype(Array)

Array |> supertype |> supertype

isabstracttype(AbstractArray)

typeof(AbstractArray)

# #### コード4-34. 配列型の基本型（パラメトリック抽象型）の例 (2)

isabstracttype(AbstractArray)

isabstracttype(AbstractArray{Float64})

isabstracttype(AbstractArray{Float64, 1})

typeof(AbstractArray{Float64, 1})

# #### コード4-35. `LinearIndices`（`AbstractArray{Int}` の派生型）の性質確認例

LinearIndices <: AbstractArray

LinearIndices <: AbstractArray{Int}

supertype(LinearIndices)

isabstracttype(LinearIndices)

isconcretetype(LinearIndices)

typeof(LinearIndices)

LinearIndices(ones(2,2))

typeof(LinearIndices(ones(2,2)))

isconcretetype(typeof(LinearIndices(ones(2,2))))

typeof(typeof(LinearIndices(ones(2,2))))

supertype(typeof(LinearIndices(ones(2,2))))

LinearIndices(ones(2,2)) isa AbstractArray{Int64, 2}

LinearIndices{2} <: AbstractArray{Int64, 2}

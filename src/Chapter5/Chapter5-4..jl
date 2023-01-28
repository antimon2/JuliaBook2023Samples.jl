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

# ## 5-4. 演算子オーバーロード

# ### 5-4-2. 実例

# #### コード5-24.	Point2D.jl（加算・減算の定義を含む）

# +
abstract type AbstractPoint{T<:Real} end

struct Point2D{T} <: AbstractPoint{T}
    x::T
    y::T
end

function Base.:+(p1::Point2D, p2::Point2D)
    Point2D(p1.x + p2.x, p1.y + p2.y)
end

Base.:-(p1::Point2D, p2::Point2D) = Point2D(p1.x - p2.x, p1.y - p2.y)
# -

# #### コード5-25. `Point2D` の動作例（`+`/`-` 演算子による加減算）

p1 = Point2D(1.0, 2.0)

p2 = Point2D(3.0, 4.0)

p1 + p2

p1 - p2

# #### 仮想コード5-1.	`+` 演算子を誤って多重定義してしまった際のエラー例

# ```julia
# julia> p1 + p2
# ERROR: MethodError: no method matching +(::Float64, ::Float64)
# You may have intended to import Base.:+
# Stacktrace:
#  [1] +(p1::Point2D{Float64}, p2::Point2D{Float64})
#    @ Main ./REPL[XX]:2
#  [2] top-level scope
#    @ REPL[YY]:1
# ```

# #### 仮想コード5-2.	`+` 演算子を誤って多重定義しようとしてしまった際のエラー例（REPL）

# ```julia
# julia> function (+)(p1::Point2D, p2::Point2D)
#            Point2D(p1.x + p2.x, p1.y + p2.y)
#        end
# ERROR: error in method definition: function Base.+ must be explicitly imported to be extended
# Stacktrace:
#  [1] top-level scope
#    @ none:0
#  [2] top-level scope
#    @ REPL[XX]:1
# ````

# ### 5-4-3. 型昇格ルール

# #### コード5-26.	型昇格（`promote()`）の例

promote(1, 2)

typeof((1, 2))

typeof(promote(1, 2))

promote(1, 3.4)

typeof((1, 3.4))

typeof(promote(1, 3.4))

# #### コード5-27.	`promote()` の利用を伴う関数（演算子）の多重定義例

⊓(x::Real, y::Real) = ⊓(promote(x, y)...)

⊓(x::T, y::T) where {T <: Real} = max(x, y)

1 ⊓ 2

3.4 ⊓ 1.2

4 ⊓ π

3f0 ⊓ 4

3f0 ⊓ 4 ⊓ 2.0

# #### 仮想コード5-3. `GeometricSequence` の定義例中における `promote()` の利用例（前節のコード5-20.より抜粋再掲）

# ```julia
# function GeometricSequence(a::T1, r::T2, n::Integer) where {T1<:Number, T2<:Number}
#     GeometricSequence(promote(a, r)..., Int(n))
# end
# ```

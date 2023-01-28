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

# ## 4-6. 特殊な型

# ### 4-6-1. Tuple型・NamedTuple型

# #### コード4-58. Tuple型 の確認例

typeof((1, 2))

typeof((1, 99.9, :a))

typeof((1,))

typeof(())

# #### コード4-59. Tuple型 の性質・サブタイピングの確認例

isabstracttype(Tuple)

isconcretetype(Tuple)

isconcretetype(Tuple{})

isconcretetype(Tuple{Int})

typeof(Tuple)

typeof(Tuple{Int})

supertype(Tuple)

subtypes(Tuple)

Tuple{Int} <: Tuple

Tuple{Int, Int} <: Tuple{Int}

Tuple{Int} <: Tuple{Integer} <: Tuple{Any}

Tuple{Int64, Float64, Symbol} <: NTuple{3, Any}

# #### コード4-60. NamedTuple型 の確認例

nt = (a=1, b=2.1, c=:OK)

typeof(nt)

nt1 = (a=1,)  # `(;a=1)` と書いても同じ

typeof(nt1)

nt0 = (;)

typeof(nt0)

# #### コード4-61. `@NamedTuple` マクロの例

@NamedTuple begin
    a::Int
    b::Float64
    c::Symbol
end

@NamedTuple{a::Int, b::Float64, c::Symbol}

@NamedTuple{a, b}

@NamedTuple{}

# #### コード4-62. NamedTuple型 の性質・サブタイピングの確認例

supertype(NamedTuple)

subtypes(NamedTuple)

isabstracttype(NamedTuple)

isconcretetype(NamedTuple)

typeof(NamedTuple)

typeof(@NamedTuple{})

@NamedTuple{a::Int, b::Float64, c::Symbol} <: @NamedTuple{a, b, c}

# ### 4-6-2. Union型

# #### コード4-63. Union型 の例

Union{Int, String}

Union{Int, Float64, String}

Union{Int, Integer}

Union{Int, Int} === Union{Int} === Int

# #### コード4-64. Union型 のサブタイピング・性質等の確認例

isabstracttype(Union{Int, String})

isconcretetype(Union{Int, String})

supertype(Union{Int, String})

subtypes(Union{Int, String})

Union{Int, String} <: Any

Int <: Union{Int, String}

String <: Union{Int, String}

Float64 <: Union{Int, String}

Union{Int, String} <: Union{Int, String, Float64}

Union{Int, String} <: Union{Integer, String}

Union{Int, String} <: Union

typeof(Union{Int, String})

# ### 4-6-3. ボトム型

# #### コード4-65. `Union{}`（ボトム型）の確認例

Union{}

typeof(Union{})

Union{} <: Int

all(Union{} <: T for T in (Float64, String, Number, Any))

# ### 4-6-4. シングルトン型

# #### コード4-66. シングルトン型の定義例 (1)

struct MySingleton end

# #### コード4-67. シングルトン型の使用例 (1)

a = MySingleton()

b = MySingleton()

a === b

Base.issingletontype(MySingleton)

# #### コード4-68. シングルトン型の定義例 (2)：パラメトリック型のシングルトン型

struct ParametricSingleton{T} end

# #### コード4-69. パラメトリック型のシングルトン型の確認例

Base.issingletontype(TParametricSingleton)

Base.issingletontype(ParametricSingleton{Int})

ParametricSingleton{Int}() === ParametricSingleton{Int}()

ParametricSingleton{String}() === ParametricSingleton{String}()

ParametricSingleton{Int}() === ParametricSingleton{String}()

ParametricSingleton{1}() === ParametricSingleton{1}()

ParametricSingleton{:OK}() === ParametricSingleton{:OK}()

# #### コード4-70. 標準で定義されているシングルトン（`nothing`、`missing`）の例

Base.issingletontype(Nothing)

Nothing() === nothing

Base.issingletontype(Missing)

Missing() === missing

# ### 4-6-5. `Type{T}` 型セレクタ

# #### コード4-71. `Type` 型の派生型の確認

subtypes(Type)

# #### コード4-72. `Type{T}` の性質確認

typeof(Type)

typeof(Type{Int})

Int isa Type{Int}

Float64 isa Type{Int}

Int isa Type{Integer}

typeof(Int) <: Type{Int}

all(T isa Type{T} for T in (Float64, String, typeof(1 + im), Any))

all(T isa Type{<:Real} for T in (Int, Float64, Signed, AbstractFloat))

# ### 4-6-6. 型エイリアス

# #### コード4-73. 型エイリアスの例

typeof(1.0 + 1.0im)

typeof([1. 2.; 3. 4.])

Vector

# #### コード4-74. 型エイリアスの定義例

struct ParametricSingleton{T} end

const IntParamSingleton = ParametricSingleton{Int}

const IntegerParamSingleton{T<:Integer} = ParametricSingleton{T}

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

# ## 4-2. 公称型システムとサブタイピング

# ### 4-2-1. 公称型システム

# #### コード4-1. `typeof()` 関数の例（具象型の確認）

typeof("文字列")

typeof(99.9)

typeof(1) === Int

# ### 4-2-2. 基本型と派生型

# #### コード4-2. 派生型演算子（`<:`）と基本型演算子（`>:`）の例

Int <: Number

Number >: Int

Number <: Int

Float64 <: Number

Int <: Float64

Int >: Float64

Int <: Int

# #### コード4-3. `isa()` 関数の例 (1)

isa(1, Int)

isa(1, Number)

isa(1, Float64)

isa(99.9, Float64)

isa(99.9, Number)

isa(99.9, Int)

# #### コード4-4. `isa()` 関数の例 (2)：演算子としての使用例

isa(1, Int)

1 isa Int

# ### 4-2-3. 型階層

# #### コード4-5. `supertype()` の例 (1)

supertype(Int)

supertype(Float64)

# #### コード4-6. `supertype()` の例 (2)

supertype(Int)

supertype(supertype(Int))

supertype(supertype(supertype(Int)))

supertype(supertype(supertype(supertype(Int))))

# #### コード4-7. `supertype()` の例 (3)

Int |> supertype

Int |> supertype |> supertype

Int |> supertype |> supertype |> supertype

Int |> supertype |> supertype |> supertype |> supertype

# #### コード4-8. `supertype()` の例 (4)

Float64 |> supertype

Float64 |> supertype |> supertype

Float64 |> supertype |> supertype |> supertype

# #### コード4-9. `<:` による基本型の確認例

Int <: Signed <: Integer <: Real <: Number

Float64 <: AbstractFloat <: Real <: Number

# #### コード4-10. `subtypes()` の例 (1)

subtypes(Number)

# #### コード4-11. `subtypes()` の例 (2)

subtypes(Real)

# #### コード4-12. 型定義の例 (1)

struct Decimal <: Real
    value::BigInt
    point::Int
end

# ### 4-2-4. 抽象型と具象型

# #### コード4-13. `isabstracttype()`/`isconcretetype()` の例

isabstracttype(Int)

isconcretetype(Int)

isabstracttype(Float64)

isconcretetype(Float64)

isabstracttype(Number)

isconcretetype(Number)

isconcretetype(typeof("文字列"))

isabstracttype(supertype(typeof("文字列")))

# #### コード4-14. 基本型が抽象型であることの確認例

all(isabstracttype(supertype(T)) for T in [
    Int, Float64, String,
    Real, Number, supertype(Number), supertype(supertype(Number)),
    typeof(:sym), typeof([1, 2, 3]), typeof(("a", 1, 3.14)),
    typeof(Set(i^2 % 5 for i=1:8))
])

# #### コード4-12. 型定義の例 (1)（再掲）

struct Decimal <: Real
    value::BigInt
    point::Int
end

# #### コード4-15. 型定義の例 (2)：NG例

struct DecimalEx <: Decimal end

# #### コード4-16. 具象型に対する `subtypes()` の適用例

subtypes(Int)

# ### 4-2-5. Any型

# #### コード4-17. `typejoin()` の例

typejoin(Int, Float64)

typejoin(Float64, Int)

typejoin(Float64, Int, typeof(1 + 1im))

typejoin(Int, Int) === typejoin(Int) === Int

typejoin(Int, String)

# #### コード4-18. `Any` 型の性質確認例 (1)

isabstracttype(Any)

length(subtypes(Any))

supertype(Any)

# #### コード4-19. `Any` 型の性質確認例 (2)

Int <: Any

Any <: Any

99.9 isa Any

typejoin(typeof("文字列"), Any)

# #### コード4-20. 基本型が `Any` になることの確認例

Int |> supertype

Int |> supertype |> supertype

Int |> supertype |> supertype |> supertype

Int |> supertype |> supertype |> supertype |> supertype

Int |> supertype |> supertype |> supertype |> supertype |> supertype

String |> supertype

String |> supertype |> supertype

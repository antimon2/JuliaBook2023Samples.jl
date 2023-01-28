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

# ## 8-4. 解析と評価

# ### 8-4-1. `Meta.parse()`

# #### コード8-9. `Meta.parse()` の例(1)

src1 = "1 + 1"

ex1 = Meta.parse(src1)

dump(ex1)

Meta.parse("p1 ∧ p2")  # `∧` は `\wedge`+TAB で入力できます

dump(Meta.parse("p1 ∧ p2"))

Meta.parse("a")

typeof(Meta.parse("a"))

Meta.parse("\"文字列\"")

typeof(Meta.parse("\"文字列\""))

Meta.parse("(a + b)2")

(a + b)2

# #### コード8-10. `Meta.parse()` の例(2)

Meta.parse(join(["a$i" for i in 1:5], "+"))
# eqivalent to `Meta.parse("a1+a2+a3+a4+a5")`

Meta.parse(strip("#a + b#2", ['#', '2']))
# equivalent to `Meta.parse("a + b")`

# ### 8-4-2. `eval()`

# #### コード8-11. `eval()` の例(1)

ex1 = Meta.parse("1 + 1")  # `ex1 = :(1 + 1)` としても全く同じ

eval(ex1)  # `1 + 1` の結果を返す

a = 97;
eval(:a)  # シンボルを渡すとその識別子が表す値を返す

ex2 = :(a + b)

eval(ex2)  # `b` にまだ何も代入されていないのでエラーとなる

b = 3;
eval(ex2)  # エラーにならず `a + b`（＝`97 + 3`）の結果を返す

# #### コード8-12. `:(a + b - c)`

ex3 = :(a + b - c)

dump(ex3)

# #### コード8-13. `eval(:(a + b - c))` の評価の流れ（エミュレーション）

a = 1; b = 3; c = 2;

ex3.args[1]

eval(ex3.args[1])

ex3.args[2]

ex3.args[2].args[1]

eval(ex3.args[2].args[1])

ex3.args[2].args[2]

eval(ex3.args[2].args[2])

ex3.args[2].args[3]

eval(ex3.args[2].args[3])

eval(ex3.args[2])  # compute `1 + 3`

ex3.args[3]

eval(ex3.args[3])

eval(ex3)  # compute `4 - 2`

# #### コード8-14. `ex4 = :(iseven(a) ? :even : :odd)` とその評価

ex4 = :(iseven(a) ? :even : :odd)

dump(ex4)

a = 1

ex4.head

ex4.args[1]

ex4.args[1].head

ex4.args[1].args[1]

eval(ex4.args[1].args[1])

ex4.args[1].args[2]

eval(ex4.args[1].args[2])

eval(ex4.args[1])

ex4.args[3]

eval(ex4.args[3])

eval(ex4)

# ### 8-4-3. 式展開

# #### コード8-15. `Expr` の式展開の例(1)

a = 97;
ex3 = :($a + b)

b = 3;
eval(ex3)  # `97 + b` が評価される

a = 0; b = 1;  # ここで `a` に別の値を代入しても `ex3` に影響はない
eval(ex3)  #  `97 + b` が評価される

ex3a = :($(a + b) + c)  # `a == 0`, `b == 1` なので `a + b == 1`

c = 10;
eval(ex3a)

# #### コード8-16. `Expr` の式展開の例(2)

args = (n^2 for n=1:5);

ex4_fn = :(fn($(args...)))

ex4_fn2 = :(fn(0, $(args...)))

ex4_vector = :([$(args...)])

ex4_vector = :([0, $(args...)])

ex4_tuple = :(($(args...),))

ex4_tuple = :((0, $(args...)))

"$(args...)"  # 参考（比較）

# #### コード8−17. `Expr` の式展開の例(3)

qx = :x;
qy = :y;
ex5_add = :($qx + $qy)

x = 3;
y = 4;
eval(ex5_add)

args = (:x, :y, 5);
ex5_muladd = :(muladd($(args...)))

eval(ex5_muladd)

qs_even = QuoteNode(:even);
qs_odd = QuoteNode(:odd);
quote
    if iseven(a)
        $qs_even
    else
        $qs_odd
    end
end |> Base.remove_linenums!

# #### コード8-18. `Expr` の式展開の例(4)

dump(:(1//2 + 1))

dump(:($(1//2) + 1))  # `1//2` という「値」をアンクォート

dump(:($(:(1//2)) + 1))  # `:(1//2)` という `Expr` をアンクォート

:($(:(1//2)) + 1) == :(1//2 + 1)

# ### 8-4-4. コードの動的生成

# #### コード8-19. `OSType` の定義(1): 基本実装

abstract type OSType end

OSType(osname) = OSType(Val(Symbol(osname)))

struct OtherOS <: OSType
    name::Symbol
end

OSType(::Val{other}) where {other} = OtherOS(other)

Base.print(io::IO, other::OtherOS) = print(io, other.name)

# #### 仮想コード8-1. `OSType` の定義(2): `Linux` 型の追加

# ```julia
# struct Linux <: OSType end
#
# OSType(::Val{:Linux}) = Linux()
#
# Base.print(io::IO, ::Linux) = print(io, "Linux")
# ```

# #### コード8-20. `OSType` の定義(3): 複数の型の一括定義

# ```julia
# for osname in ["Linux", "Mac", "Windows"]
#     typename = Symbol(osname)
#     eval(:(struct $typename <: OSType end))
#     eval(:(OSType(::Val{$(QuoteNode(typename))}) = $typename()))
#     eval(:(Base.print(io::IO, ::$typename) = print(io, $osname)))
# end
# ```

# #### コード8-21. `OSType` の定義(4): 複数の型の一括定義(改)

for osname in ["Linux", "Mac", "Windows"]
    typename = Symbol(osname)
    @eval struct $typename <: OSType end
    @eval OSType(::Val{$(QuoteNode(typename))}) = $typename()
    @eval Base.print(io::IO, ::$typename) = print(io, $osname)
end

# #### コード8-22. `OSType` の動作確認

subtypes(OSType)

OSType.([:Linux, :Mac, :Windows, :FreeBSD])

OSType.([:Linux, :Mac, :Windows, :FreeBSD]) .|> string

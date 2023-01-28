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

# ## 8-5. マクロ

# ### 8-5-1. Juliaのマクロ呼び出し

# #### 仮想コード8-2. マクロ呼び出しの書式

# ```julia
# @somemacro0
# @somemacro0()
#
# @somemacro1 《式1》
# @somemacro1(《式1》)
#
# @somemacro2 《式1》 《式2》
# @somemacro2(《式1》, 《式2》)
#
# # :《以下同様》
# ```

# #### コード8-23. `@__MODULE__` マクロの例

@__MODULE__

@__MODULE__()

getproperty(@__MODULE__, :Int)  # OK

getproperty(@__MODULE__(), :Int)  # これもOK

@__MODULE__ === Main  # これはNG

@__MODULE__() === Main  # これならOK

(@__MODULE__) === Main  # これもOK

Main === @__MODULE__  # これもOK

# #### コード8-24. `@time`/`@timed` マクロの例

function fib(n)
    if n ≤ 1
        n
    else
        fib(n - 2) + fib(n - 1)
    end
end

@time fib(40)  # `@time(fib(40))` でも同様

stats = @timed fib(40)

stats.value

@timed(fib(40)).time  # `(@timed fib(40)).time`  でも同様

# #### コード8-25. `@show` マクロの例

a, b = 1, 2;

@show a

@show a + b  # == `@show(a + b)`

@show a b  # == `@show(a, b)`

@show a, b  # == `@show((a, b))`

# ### 8-5-2. マクロの定義

# #### コード8-26. `@time_ns` マクロの定義例（コード1-6.再掲）

macro time_ns(ex)
    ex = esc(ex)
    quote
        t0 = time_ns()
        val = $ex
        t1 = time_ns()
        println("elapsed time: ", Int(t1-t0), " nanoseconds")
        val
    end
end

# #### コード8-27. マクロ `@qte` の定義

macro qte(ex)
    QuoteNode(ex)
end

# #### コード8-28. マクロ `@qte` の使用例(1)

@qte fib(40)

@qte a + b

@qte(:a)

@qte begin
    x = 1
    y = 2
    x + y
end

# #### コード8-29. マクロ `@qte` の使用例(2)

@qte $(1 + 2)

qx = :x; qy = :y;
ex5_add_q = @qte $qx + $qy

args = (:x, :y, 5);
ex5_muladd_q = @qte(muladd($(args...)))

# #### コード8-30. マクロ `@qte` の定義その2（多重定義）

macro qte(ex1, ex2...)
    QuoteNode((ex1, ex2...))
end

# #### コード8-31. マクロ `@qte` の使用例(3)

methods(var"@qte")

@qte a + b  # 1つの式（演算式）⇒引数1つのメソッドが呼ばれる

@qte a + b c - d  # 2つの式⇒引数2つ以上のメソッドが呼ばれる

@qte(1, :a, sin(π))  # 3つの引数が指定されたものと見なされ、引数2つ以上のメソッドが呼ばれる

@qte 1, :a, sin(π)  # 「カンマ区切りで式を並べた式（つまりタプル）」と見なされ、引数1つのメソッドが呼ばれる

# ### 8-5-3. マクロの動作原理

# #### コード8-32. `@macroexpand` マクロの紹介

@macroexpand @__MODULE__

@macroexpand @qte fib(40)

@macroexpand @. A * sin(x) + b

@macroexpand @eval $qx + $qy

# #### コード8-33. `@rand1to10` マクロの定義

macro rand1to10()
    rand(1:10)
end

# #### コード8-34. `@rand1to10` マクロの動作確認

@macroexpand @rand1to10

@macroexpand @rand1to10

@macroexpand @rand1to10

@rand1to10

@rand1to10

@rand1to10

sample_rand1to10(DUMMY...) = @rand1to10

sample_rand1to10()

sample_rand1to10()

sample_rand1to10()

sample_rand1to10(1)

sample_rand1to10(1, 2, 3)

sample_rand1to10(Symbol)

# #### コード8-35. `@assert` マクロの例

@macroexpand @assert iseven(a)

function a_div_2(a)
    @assert iseven(a)
    a ÷ 2
end

a_div_2(100)

a_div_2(101)

# #### 仮想コード8-3. `@assert` マクロを含む関数と同等の関数定義

# ```julia
# function a_div_2(a)
#     if iseven(a)
#         nothing
#     else
#         throw(AssertionError("iseven(a)"))
#     end
#     a ÷ 2
# end
# ```

# #### コード8-36. マクロを含む関数定義への `@macroexpand` の適用

@macroexpand(function a_div_2(a)
    @assert iseven(a)
    a ÷ 2
end) |> Base.remove_linenums!

# ### 8-5-4. 衛生的なマクロ

# #### コード8-26. `@time_ns` マクロの定義例（再掲）

macro time_ns(ex)
    ex = esc(ex)
    quote
        t0 = time_ns()
        val = $ex
        t1 = time_ns()
        println("elapsed time: ", Int(t1-t0), " nanoseconds")
        val
    end
end

# #### コード8-37. `@time_ns` マクロの実行例(1)

@time_ns 1 + 1

@time_ns time_ns()

# #### コード8-38. `@time_ns` マクロの実行例(2)

function chk_t0()
    @time_ns t0 += 1000000
end

chk_t0()

@macroexpand(function chk_t0()
    @time_ns t0 += 1000000
end) |> Base.remove_linenums!

# #### コード8-39. `gensym()`/`@gensym` の実行例

gensym()

gensym("ABC")  # `gensym(:ABC)` でもOK

gensym("x", "y", "z")  # こちらは各引数シンボルは受け付けないので注意！

@gensym x y z  # この呼び出し自体は値がない（`nothing` が返る）

(x, y, z)

# #### コード8-40. `gensym()`（`@gensym`）利用例

macro use_gensym()
    @gensym result
    quote
        $result = rand()
    end
end

@macroexpand @use_gensym

# ### 8-5-5. 実例

# #### コード8-41. `OSTypes.jl`（`OSTypes` モジュールの定義）

# +
module OSTypes

export OSType, Linux, Mac, Windows, OtherOS, @genostype

abstract type OSType end

OSType(osname) = OSType(Val(Symbol(osname)))

struct OtherOS <: OSType
    name::Symbol
end
OSType(::Val{other}) where {other} = OtherOS(other)
Base.print(io::IO, other::OtherOS) = print(io, other.name)

function _genostype(typename)
    osname = string(typename)
    typeid = esc(typename)
    basetype = esc(:(OSTypes.OSType))
    quote
        struct $typeid <: $basetype end
        $basetype(::Val{$(QuoteNode(typename))}) = $typeid()
        Base.print(io::IO, ::$typeid) = print(io, $osname)
    end
end

macro genostype(typename::Symbol)
    _genostype(typename)
end

macro genostype(typenames::Symbol...)
    Expr(:block, (_genostype(typename) for typename in typenames)...)
end

@genostype Linux Mac Windows

end
# -

# #### コード8-42. `OSTypes` モジュールの使用例（`@genostype` の動作例）

using .OSTypes

Linux()

[OSType(osname) for osname in (:Linux, :Mac, :Windows, :FreeBSD, :Haiku)]

@genostype FreeBSD  # 現在のモジュールに新しい型 `FreeBSD` が追加される

[OSType(osname) for osname in (:Linux, :Mac, :Windows, :FreeBSD, :Haiku)]

OSType.((:Linux, :Mac, :Windows, :FreeBSD, :Haiku)) .|> string

# ### 8-5-6. 非標準文字列リテラルとコマンドリテラル

# #### 仮想コード8-4. `r"～"`/`raw"～"` の定義例

# ```julia
# # `r"～"` の定義（例）
# macro r_str(pattern, flags...)
#     Regex(pattern, flags...)
# end
#
# # `raw"～"` の定義（例）
# macro raw_str(str)
#     str
# end
# ```

# #### コード8-43. `XX"～"` の確認（`@XX "～"` との比較）

dump(:(XX"abc"))

dump(:(@XX_str "abc"))

# #### コード8-44. オリジナル非標準文字列リテラル `basedint"～"xx` の例

macro basedint_str(str, base=10)
    parse(Int, str, base=base)
end

basedint"12"  # 10進表記の `12`

basedint"12"3  # 3進表記の `12`

basedint"12"16  # 16進表記の `12`

basedint"12"25  # 25進表記の `12`

# #### コード8-45. 正規表現オブジェクト（コンストラクタ呼び出し）と正規表現リテラルのパフォーマンス比較

using Random

lines = [randstring(['0':'9';'A':'Z'], 100) for _ in 1:10000];

@time for line in lines
    m = match(Regex("\\d{4}"), line)
    m === nothing || print(devnull, m.match)
end

@time for line in lines
    m = match(r"\d{4}", line)
    m === nothing || print(devnull, m.match)
end

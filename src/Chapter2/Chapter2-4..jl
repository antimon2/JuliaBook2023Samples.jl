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

# ## 2-4. 関数

# ### 2-4-1. 関数呼び出し

# #### 関数呼び出しの基本

# ##### コード2-38. 関数呼び出しの例(1)：1引数の関数呼び出し（`sin()` の例）

sin(0.0)

sin(π/4)

# ##### コード2-39. 関数呼び出しの例(2)：引数なしの関数呼び出し（`rand()` の例）

rand()

rand()

# ##### コード2-40. 関数呼び出しの例(3)：複数引数の関数呼び出し（`rand()` の例）

rand(Int)

rand(UInt32, 2)

rand(Float64, (2, 3))

# #### キーワード引数

# ##### コード2-41. 関数呼び出しの例(4)：キーワード引数（`string()` の例）

string(123)

string(123, pad=4)

string(123, base=16)

string(123, base=16, pad=4)

# #### 引数展開

# ##### コード2-42. 関数呼び出しの例(5)：引数展開（`promote()` の例）

a = (1, 2//3, 4.5);

promote(a[1], a[2], a[3])

promote(a...)

# ### 2-4-2. 関数定義

# #### 関数定義の基本

# ##### コード2-43. 関数定義の例(1)

function add(x, y)
    x + y
end

add(1, 2)

add(0x03, 0x04)

add(1.2, 3.4)

# ##### コード2-44. 関数定義の例(2)：予約語 `function` を伴わない例

f(x) = x^2 + 2x - 1

f(1)

f(2.5)

# ##### 仮想コード2-2. 関数定義の例(3)：先に定義した関数と同じものの別定義

# ```julia
# add(x, y) = x + y
#
# function f(x)
#     x^2 + 2x - 1
# end
# ```

# #### 無名関数

# ##### コード2-45. 関数定義の例(4)：無名関数の定義例(1)

x -> x^2 + 2x - 1

function (x, y)
    x + y
end

# ##### コード2-46. 無名関数の使用例（高階関数への指定）

map(x -> x^2 + 2x - 1, 1:10)

sum(x -> x^2 + 2x - 1, 1:10)

# ##### コード2-47. 関数定義の例(5)：無名関数の定義例(2)

() -> time()

(x, y) -> 2x + y

# #### 関数の多重定義

# ##### コード2-48. 関数定義の例(6)：関数の多重定義例（`add()` の例）

add(x, y, z) = x + y + z

add(1, 2, 3)

add(2, 3)

# ##### コード2-49. 多重定義した関数（`add()`）のメソッドの確認

add

methods(add)

# #### 可変長引数

# ##### コード2-50. 関数定義の例(7)：可変長引数の指定例（`add()` の多重定義例）

function add(x, y, z...)
    add(x + y, z...)
end

methods(add)

add(1, 2)

add(1, 2, 3)

add(1, 2, 3, 4)

add(1, 2, 3, 4, 5)

add(1, 2, 3, 4, 5, 6)

# #### オプショナル引数/キーワード引数

# ##### コード2-51. 関数定義の例(8)：オプショナル引数の指定例

f2(x, y=1, z=0) = x + y + z

f2(1)

f2(1, 2)

f2(1, 2, 3)

methods(f2)

# ##### コード2-52. 関数定義の例(9):キーワード引数の指定例

f3(x; y=1, z=0) = x + y + z

f3(1)

f3(1, y=2)

f3(1, z=3)

f3(1, y=2, z=3)

f3(1, z=3, y=2)

# ##### コード2-53. オプショナル引数指定の実例（標準関数 `lpad()`/`rpad()` の例）

lpad("abc", 5, '-')

lpad("abc", 5)

rpad("abc", 5, '_')

rpad("abc", 5)

# ##### コード2-54. キーワード引数指定の実例（標準関数 `string()` の例）

string(123)

string(123, pad=4)

string(123, base=16)

string(123, base=16, pad=4)

# ##### コード2-55. キーワード引数展開の例

params = (base=16, pad=4)

string(123; params...)  # `string(123; base=16, pad=4)` と等価

# #### 型アノテーション

# ##### コード2-56. 関数定義の例(10)：型アノテーションの指定例

function addint(x::Integer, y::Integer)::Int
    x + y
end

addint(1, 2)

addint(0x03, 0x04)

addint(1.0, 2.0)

# #### `return` 文

# ##### コード2-57. 関数定義の例(11)：`return` の指定例(1)

function fib_simple(n)
    if n ≤ 1
        return n
    end
    fib_simple(n - 1) + fib_simple(n - 2)
end

# ##### コード2-58. 関数定義の例(12)：`return` の指定例(2)

function emptyfunction()
    return
end

typeof(emptyfunction())

# ### 2-4-3. 関数適用演算子

# #### コード2-59. 複雑な関数呼び出し（多重ネスト）

println(sqrt(sum(1:2:20)))

# #### コード2-60. パイプライン演算子の使用例

1:2:20 |> sum |> sqrt |> println

# #### コード2-61. 関数合成演算子の使用例

(println ∘ sqrt ∘ sum)(1:2:20)

# #### コード2-62. パイプライン演算子と関数合成演算子の組合せ使用例

1:2:20 |> sqrt ∘ sum |> println

# #### コード2-63. パイプライン演算子・関数合成演算子と無名関数の組合せ使用例

1:2:20 |> sum |> (x -> x^2) |> println

(println ∘ (x -> x^2) ∘ sum)(1:2:20)

1:2:20 |> (x -> x^2) ∘ sum |> println

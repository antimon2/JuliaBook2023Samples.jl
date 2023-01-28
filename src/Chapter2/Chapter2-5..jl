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
#     display_name: Julia (4 threads) 1.8.5
#     language: julia
#     name: julia-_4-threads_-1.8
# ---

versioninfo()

# ## 2-5. 制御構文

# ### 2-5-1. 条件分岐

# #### コード2-64. `if` の使用例(1)

function test1(x, y)
    if x < y
        println("x は y より小さい")
    elseif x > y
        println("x は y より大きい")
    else
        println("x と y は等しい")
    end
end

test1(1, 2)

test1(1, 0)

test1(99, 99)

# #### コード2-65. `if` の使用例(2)

function test2(x, y)
    result = if x < y
        "x は y より小さい"
    elseif x > y
        "x は y より大きい"
    else
        "x と y は等しい"
    end
    println(result)
end

test2(1, 2)

test2(1, 0)

test2(99, 99)

# #### コード2-66. 三項演算子（条件分岐演算子）の使用例

function test3(x, y)
    result = x < y ? "x は y より小さい" : 
        x > y ? "x は y より大きい" : "x と y は等しい"
    println(result)
end

test3(1, 2)

test3(1, 0)

test3(99, 99)

# #### コード2-67. 論理演算子による短絡評価の例

function test4(x, y)
    x < y && return "x は y より小さい"
    x > y && return "x は y より大きい"
    "x と y は等しい"
end

println(test4(1, 2))

println(test4(1, 0))

println(test4(99, 99))

# ### 2-5-2. 繰り返し

# #### コード2-68. `while` ループの例

function while_sample()
    i = 0
    while i ≤ 5
        println(i)
        i += 1
    end
end

while_sample()

# #### コード2-69. `for` ループの例(1)：シンプルな例

function for_sample1()
    for i = 0:5
        println(i)
    end
end

for_sample1()

# #### コード2-70. `for` ループの例(2)：《in 節》の様々な表記例

for i = [2, 3, 5, 7]
    println(i)
end

for i in [2, 3, 5, 7]
    println(i)
end

for i ∈ [2, 3, 5, 7]
    println(i)
end

# #### コード2-71. `for` ループの例(3)：ネストと《in 節》の多重指定(1)

for x = 1:3
    for y = 1:2
        println((x, y))
    end
end

for x = 1:3, y = 1:2
    println((x, y))
end

# #### コード2-72. `for` ループの例(4)：ネストと《in 節》の多重指定(2)

for x = 1:3
    for y = 1:x
        println((x, y))
    end
end

for x = 1:3, y = 1:x
    println((x, y))
end

# #### コード2-73. `for` ループの例(5)：《in 節》における分割代入

d = Dict(:a => 1, :b => 2, :c => 3);

for (key, value) in d
    println("$key: $value")
end

# #### コード2-74. `break` と `continue`

function while_sample2()
    i = 1
    s = 0
    while true
        println(s)
        s ≥ 100 && break
        s += 2i - 1
        i += 1
    end
end

while_sample2()

for i = 0:10
    i % 3 == 0 || continue
    println(i)
end

# #### コード2-75. `for` ループの例(6)：《in 節》の多重指定と `break

for x = 1:9
    for y = x:9
        if x * y == 36
            println("$x * $y == 36")
            break
        end
    end
end

for x = 1:9, y = x:9
    if x * y == 36
        println("$x * $y == 36")
        break
    end
end

# ### 2-5-3. 例外処理

# #### コード2-76. 例外（エラー）の例

sqrt(2.0)

sqrt(-2.0)

# #### コード2-77. 例外処理の例

function mysqrt(x)
    try
        sqrt(x)
    catch e
        println(typeof(e))
        if e isa DomainError
            sqrt(Complex(x))
        else
            rethrow(e)
        end
    finally
        println("Done")
    end
end

mysqrt(2.0)

mysqrt(-2.0)

mysqrt("ERROR!")

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

# ## 6-3. `Iterators` サブモジュール

# #### コード6-28. `zip()` 関数の動作例

a = 1:10;
b = 'a':'j';

zip(a, b)

collect(zip(a, b))

c = ["春", "夏", "秋", "冬"];
collect(zip(a, b, c))

collect(zip(a))

# #### コード6-29. `enumerate()` 関数の動作例

b = 'a':'j';

enumerate(b)

collect(enumerate(b))

for (n, c) in enumerate(b)
    println(n-1, c)
end

collect(zip(Iterators.countfrom(2), b))

# #### コード6-30. `pairs()` 関数の動作例(1): 配列の例

b = 'a':'j';

pairs(b)

collect(pairs(b))

A = [1 2; 3 4];

collect(pairs(A))  # == collect(IndexStyle(A), pairs(A))

collect(pairs(IndexLinear(), A))

collect(pairs(IndexCartesian(), A))

# #### コード6-31. `pairs()` 関数の動作例(2): その他のコレクション型・イテレータ等

pairs(Dict(v=>2v for v=1:5))

collect(pairs(Dict(v=>2v for v=1:5)))  # == collect(Dict(v=>2v for v=1:5))

collect(pairs((1, :b, "C")))

collect(pairs((a=1, b=:b, c="C")))

collect(pairs(1))  # `keys(1) == Base.OneTo(1)`

pairs(Set([3, 1, 4, 1, 5, 9, 2, 6, 5, 3]))

# #### コード6-32. `Iterators.take()`/`Iterators.drop()`/`Iterators.takewhile()`/`Iterators.dropwhile()` 関数の動作例

using .Iterators

iter = (2^n - 1 for n=0:30);

collect(iter)

take(iter, 5)

collect(take(iter, 5))

collect(drop(iter, 26))

collect(takewhile(<(50), iter))

collect(dropwhile(<(10^8), iter))

# #### コード6-33. `Iterators.flatten()` 関数の動作例

using .Iterators

a = 1:10;
b = 'a':'j';
c = ["春", "夏", "秋", "冬"];

flatten((a, b, c))

for value in flatten((a, b, c))
    println(value)
end

# #### コード6-34. `Iterators.map()`/`Iterators.filter()` 関数の動作例

a = 1:10;

collatz(n) = iseven(n) ? n ÷ 2 : 3n + 1

map(collatz, a)

Iterators.map(collatz, a)

collect(Iterators.map(collatz, a))

filter(n->n%3==0, a)

Iterators.filter(n->n%3==0, a)

collect(Iterators.filter(n->n%3==0, a))

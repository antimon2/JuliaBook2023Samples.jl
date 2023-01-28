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

# ## 9-2. スレッド

# ### 9-2-1. Julia でスレッドを利用する

# #### コード9-21. `Threads.nthreads()` の実行結果（スレッドが有効でない場合）

# ```julia
# julia> Threads.nthreads()
# 1
# ```

# #### コード9-22. `-t` の使用例（数値を指定する場合）

# ```bash
# $ julia -t 4  # `julia --threads 4` でも同じ
# ```

# #### コード9-23. `-t` の使用例（数値を指定する場合）の動作確認

# ```julia
# julia> Threads.nthreads()
# 4
# ```

# #### コード9-24. `-t` の使用例（`auto` を指定する場合）

# ```bash
# $ julia -t auto  # `julia --threads auto` でも同じ
# ```

# #### コード9-25. `-t` の使用例（`auto` を指定する場合）の動作確認

# ```julia
# julia> Threads.nthreads()
# 12  # 結果は環境によって異なります
# ```

# #### コード9-26. Bash/Zsh など（Linux/macOS など）の環境変数指定方法

# ```bash
# # グローバルに境変数を設定してから julia を起動する例
# $ export JULIA_NUM_THREADS=4
# $ julia
#
# # 一時的な環境変数の指定と同時に julia を起動する例
# $ JULIA_NUM_THREADS=4 julia
# ```

# #### コード9-27. Powershell（Windows など）の環境変数指定方法

# ```shell
# > $env:JULIA_NUM_THREADS=4
# > julia
# ```

# #### コード9-28. `-t` の使用例（環境変数 `JULIA_NUM_THREADS` と同時に指定した場合）の動作確認

# ```julia
# julia> # Bash で `JULIA_NUM_THREADS=4 julia -t auto` 等として実行したと仮定
#
# julia> ENV["JULIA_NUM_THREADS"]  # ←環境変数の指定はこれで確認できる
# "4"
#
# julia> Threads.nthreads()
# 12  # 環境によって変わります。
# ```

# ### 9-2-2. スレッドの基本

# #### `Threads.@threads` マクロ

# #### コード9-29. `@threads` マクロの利用例(1)

Threads.nthreads()

function fib(n)
    if n ≤ 1
        n
    else
        fib(n - 2) + fib(n - 1)
    end
end

@time fib(40)

@time for _=1:4
    println(fib(40))
end

@time Threads.@threads for _=1:4
    println(fib(40))
end

# #### コード9-30. `@threads` マクロの利用例(2)、および `Threads.threadid()` の例

Threads.nthreads()

Threads.@threads for i=1:10
    println("i: ", i, ", ThreadID: ", Threads.threadid(), ", ", fib(40))
end

# #### `Threads.@spawn` マクロ

# #### コード9-31. `Threads.@spawn` マクロの利用例(1)

Threads.nthreads()

@time @sync for _=1:4
    Threads.@spawn println(fib(40))
end

@sync for x=1:2, y=3:4
    Threads.@spawn println((x, y))
end

# #### `Threads.@threads` と `Threads.@spawn` の使い分け

# #### コード9-32. `Threads.@threads` と `Threads.@spawn` の違い(1)

Threads.nthreads()

@time fib(15)

tidhist = zeros(Int, Threads.nthreads());

@time Threads.@threads for i=1:40000
    fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
    tidhist[Threads.threadid()] += 1
end

tidhist

tidhist = zeros(Int, Threads.nthreads());

@time @sync for i=1:40000
    Threads.@spawn begin
        fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

# #### コード9-33. `Threads.@threads` と `Threads.@spawn` の違い(2)

Threads.nthreads()

@time fib(25)

@time fib(35)

tidhist = zeros(Int, Threads.nthreads());

@time Threads.@threads for i=1:1000
    fib(rand(25:35))  # 毎回わずかに異なる負荷の処理が実行
    tidhist[Threads.threadid()] += 1
end

tidhist

tidhist = zeros(Int, Threads.nthreads());

@time @sync for i=1:1000
    Threads.@spawn begin
        fib(rand(25:35))  # 毎回わずかに異なる負荷の処理が実行
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

# #### `Channel(spawn=true)`

# #### コード9-34. `Channel(spawn=true)` の例(1): 単純な動作確認例

Threads.nthreads()

fib(40)

chnl = Channel{Int}(spawn=true) do chnl
    for n = 36:40
        put!(chnl, fib(n))
    end
end;

for v in chnl
    println(v)
end

# #### コード9-35. `Channel(spawn=true)` の例(2): `spawn=true` 未指定時との比較

@time begin
    chnl = Channel{Int}() do chnl
        for n = 36:40
            put!(chnl, fib(n))
        end
    end;
    for v in chnl
        @time println(fib(40) - v)
    end
end

@time begin
    chnl = Channel{Int}(spawn=true) do chnl
        for n = 36:40
            put!(chnl, fib(n))
        end
    end;
    for v in chnl
        @time println(fib(40) - v)
    end
end

# #### `Threads.foreach()`

# #### コード9-36. `Threads.foreach()` の例(1): 基本動作

Threads.nthreads()

for x=1:2, y=3:4
    println((x, y))
end

# ↑と同じ挙動をするコード
# ↓`foreach(println, [(x, y) for x=1:2 for y=3:4])` と書いても同じ
foreach([(x, y) for x=1:2 for y=3:4]) do (x, y)
    println((x, y))
end

# `Threads.@threads` を利用したマルチスレッド対応版
Threads.@threads for (x, y) in [(x, y) for x=1:2 for y=3:4]
    println((x, y))
end

# `Threads.foreach()` を利用する場合、まず `Channel` を準備
chnl = Channel() do chnl
    for x=1:2, y=3:4
        put!(chnl, (x, y))
    end
end;

# ↓ `Threads.foreach(println, chnl)` と書いても同じ
Threads.foreach(chnl) do (x, y)
    println((x, y))
end

# #### コード9-37. `Threads.foreach()` の例(2): `Base.foreach()` と仕様を合わせる例

threaded_foreach(f, c::Channel) = Threads.foreach(f, c)

function threaded_foreach(f, itr)
    channel = Channel() do chnl
        for v in itr
            put!(chnl, v)
        end
    end
    Threads.foreach(f, channel)
end

function threaded_foreach(f, itrs...)
    channel = Channel() do chnl
        for args in zip(itrs...)
            put!(chnl, args)
        end
    end
    Threads.foreach(args -> f(args...), channel)
end

threaded_foreach(f) = foreach(f)

foreach(println, 1:3)

threaded_foreach(println, 1:3)  # 実行する度に結果は変わります

foreach((x, y) -> println(x + y), 1:3, 4:6)

threaded_foreach((x, y) -> println(x + y), 1:3, 4:6)  # 実行する度に結果は変わります

# #### コード9-38. `Threads.foreach()` の例(3): `schedule` キーワード引数の指定による挙動の差異(1)

Threads.nthreads()

@time fib(15)

tidhist = zeros(Int, Threads.nthreads());

@time begin
    chnl = Channel{Int}() do chnl
        for i=1:40000
            put!(chnl, i)
        end
    end
    Threads.foreach(chnl) do i
        fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

tidhist = zeros(Int, Threads.nthreads());

@time begin
    chnl = Channel{Int}() do chnl
        for i=1:40000
            put!(chnl, i)
        end
    end
    Threads.foreach(chnl, schedule=Threads.StaticSchedule()) do i
        fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

# #### コード9-39. `Threads.foreach()` の例(3): `schedule` キーワード引数の指定による挙動の差異(2)

Threads.nthreads()

@time fib(15)

@time fib(25)

tidhist = zeros(Int, Threads.nthreads());

@time begin
    chnl = Channel{Int}() do chnl
        for i=1:10000
            put!(chnl, i)
        end
    end
    Threads.foreach(chnl) do i
        fib(rand(15:25))  # 毎回わずかに異なる負荷の処理が実行される例
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

tidhist = zeros(Int, Threads.nthreads());

@time begin
    chnl = Channel{Int}() do chnl
        for i=1:10000
            put!(chnl, i)
        end
    end
    Threads.foreach(chnl, schedule=Threads.StaticSchedule()) do i
        fib(rand(15:25))  # 毎回わずかに異なる負荷の処理が実行される例
        tidhist[Threads.threadid()] += 1
    end
end

tidhist

# ### 9-2-3. 実用例

# #### ソートアルゴリズムの並列化

# #### コード9-40. バイトニックソートアルゴリズム（シングルスレッド版、コード5-49. 再掲）

# ```julia
# module BitonicSorterST
#
# # ref: https://en.wikipedia.org/wiki/Bitonic_sorter
#
# export BitonicSort
#
# using Base.Order: Ordering, lt
#
# struct BitonicSortAlg <: Base.Sort.Algorithm end
# const BitonicSort = BitonicSortAlg()
#
# function Base.sort!(x::AbstractVector, lo::Integer, hi::Integer, ::BitonicSortAlg, o::Ordering)
#     lo ≥ hi && return x
#
#     fullsize::Int = hi - lo
#     d = sizeof(Int) * 8 - leading_zeros(fullsize - 1)  # == ceil(Int, log(2, fullsize))
#
#     for p = 1:d, q = 1:p
#         _sort_kernel!(x, lo, hi, p, q, o)
#     end
#     return x
# end
#
# function _sort_kernel!(x::AbstractVector, lo, hi, p, q, o)
#     # @assert p ≥ q
#     halfsize_1 = Int(hi - lo) >> 0x01
#     d = 1 << UInt(p - q)
#     for s = 0:halfsize_1
#         ioff = s & (d - 1)
#         seg = lo + (s ⊻ ioff) << 0x01
#         joff = q == 1 ? (2d - ioff - 1) : ioff + d
#         i = seg + ioff
#         j = seg + joff
#         if !lt(o, x[i], x[j])
#             x[i], x[j] = x[j], x[i]
#         end
#     end
# end
#
# end # module
# ```

include("../Chapter5/BitonicSorterST.jl")

# #### コード9-41. バイトニックソートアルゴリズム（マルチスレッド版）

# ```julia
# module BitonicSorterMT
#
# export BitonicSortMT
#
# using Base.Order: Ordering, lt
#
# struct BitonicSortMTAlg <: Base.Sort.Algorithm end
# const BitonicSortMT = BitonicSortMTAlg()
#
# function Base.sort!(x::AbstractVector, lo::Integer, hi::Integer, ::BitonicSortMTAlg, o::Ordering)
#     lo ≥ hi && return x
#
#     fullsize::Int = hi - lo
#     d = sizeof(Int) * 8 - leading_zeros(fullsize - 1)  # == ceil(Int, log(2, fullsize))
#
#     for p = 1:d, q = 1:p
#         _sort_kernel!(x, lo, hi, p, q, o)
#     end
#     return x
# end
#
# function _sort_kernel!(x::AbstractVector, lo, hi, p, q, o)
#     # @assert p ≥ q
#     halfsize_1 = (hi - lo) >> 0x01
#     d = 1 << UInt(p - q)
#     Threads.@threads for s = 0:halfsize_1
#         ioff = s & (d - 1)
#         seg = lo + (s ⊻ ioff) << 0x01
#         joff = q == 1 ? (2d - ioff - 1) : ioff + d
#         i = seg + ioff
#         j = seg + joff
#         if !lt(o, x[i], x[j])
#             x[i], x[j] = x[j], x[i]
#         end
#     end
# end
#
# end # module
# ```

include("BitonicSorterMT.jl")

# #### コード9-42. バイトニックソートの動作確認・比較

Threads.nthreads()

using .BitonicSorterST, .BitonicSorterMT

x_org = [10, 30, 11, 20, 4, 330, 21, 110];

# デフォルトアルゴリズムでソート
sort(x_org)

# BitonicSortでソート
sort(x_org; alg=BitonicSort)

# BitonicSortMTでソート
sort(x_org; alg=BitonicSortMT)

x_org_2_16 = rand(Float64, 2^16);

sort(x_org_2_16) == 
sort(x_org_2_16; alg=BitonicSort) ==
sort(x_org_2_16; alg=BitonicSortMT)

using BenchmarkTools

@btime sort($x_org_2_16);

@btime sort($x_org_2_16; alg=BitonicSort);

@btime sort($x_org_2_16; alg=BitonicSortMT);

# #### `Iterators.map` のマルチスレッド化

# #### コード9-43. `threaded_map()`（マルチスレッド版 `map()`）の実装例

threaded_map(f) = map(f)

function threaded_map(f, itr)
    ntasks = Threads.nthreads()
    intermediate_channel = Channel{Task}(ntasks; spawn=true) do chnl
        for arg in itr
            put!(chnl, Threads.@spawn(f(arg)))
        end
    end
    (fetch(task) for task in intermediate_channel)
end

function threaded_map(f, itrs...)
    ntasks = Threads.nthreads()
    intermediate_channel = Channel{Task}(ntasks; spawn=true) do chnl
        for args in zip(itrs...)
            put!(chnl, Threads.@spawn(f(args...)))
        end
    end
    (fetch(task) for task in intermediate_channel)
end

# #### コード9-44. `threaded_map()`（マルチスレッド版 `map()`）の動作確認例

Threads.nthreads()

map(+, 1:3, 4:6)

collect(threaded_map(+, 1:3, 4:6))  # 結果（要素順序）も同じであることにも注目

function fib(n)
    if n ≤ 1
        n
    else
        fib(n - 2) + fib(n - 1)
    end
end

map(fib, 40:-1:21)

collect(threaded_map(fib, 40:-1:21))

@time map(fib, 40:-1:21);

@time collect(threaded_map(fib, 40:-1:21));

# #### コード9-45. `threaded_map_unordered()`の例

# 簡単のためイテレータを1つだけ受け取るもののみ実装
function threaded_map_unordered(f, itr)
    input_channel = Channel(spawn=true) do chnl
        for args in itr
            put!(chnl, args)
        end
    end
    ntasks = Threads.nthreads()
    Channel(ntasks; spawn=true) do chnl
        Threads.foreach(input_channel; ntasks=ntasks) do arg
            result = f(arg)
            put!(chnl, result)
        end
    end
end

collect(threaded_map_unordered(fib, 40:-1:21))  # 結果は順不同

@time collect(threaded_map_unordered(fib, 40:-1:21));

# ### 9-2-4. スレッドセーフ

# #### コード9-46. スレッドアンセーフの例(1)：マルチスレッドでのフィールド同時更新

Threads.nthreads()

mutable struct UnsafeCounter
    count::Int
    UnsafeCounter() = new(0)
end

counter = UnsafeCounter();

for n=1:1000
    counter.count += 1
end

counter.count
# ↓これは期待する結果

counter = UnsafeCounter();

Threads.@threads for n=1:1000
    counter.count += 1
end

counter.count
# ↓期待する結果よりも少ない値になってしまう

# #### `Threads.@atomic` マクロ（Julia v1.7 以降のみ）

# #### コード9-47. スレッドセーフの例(1)：`Threads.@atomic` による不可分操作

@assert VERSION ≥ v"1.7"
# ※注意：ここでエラーが発生するなら以降のコードは（一部）動作しません。

Threads.nthreads()

mutable struct AtomicCounter
    Threads.@atomic count::Int
    AtomicCounter() = new(0)
end

counter = AtomicCounter();

Threads.@threads for n=1:1000
    Threads.@atomic counter.count += 1
end

counter.count

counter = AtomicCounter();

for n=1:1000
    Threads.@atomic counter.count += 1  # マルチスレッドでなくても `Threads.@atomic` 必須
end

counter.count

# #### ロック機構による排他制御(1)

# #### コード9-48. スレッドセーフの例(2)：`Threads.SpinLock` による排他制御

Threads.nthreads()

mutable struct UnsafeCounter
    count::Int
    UnsafeCounter() = new(0)
end

counter = UnsafeCounter();

for n=1:1000
    counter.count += 1
end

counter.count

lck = Threads.SpinLock();

counter = UnsafeCounter();

Threads.@threads for n=1:1000
    lock(lck)
    try
        counter.count += 1
    finally
        unlock(lck)
    end
end

counter.count

lck = Threads.SpinLock();

counter = UnsafeCounter();

Threads.@threads for n=1:1000
    lock(lck) do
        counter.count += 1
    end
end

counter.count

lck = Threads.SpinLock();

counter = UnsafeCounter();

Threads.@threads for n=1:1000
    # ↓ Julia v1.7 以降は単に `@lock` でもOK
    Base.@lock lck counter.count += 1
end

counter.count

# #### コード9-49. `Threads.SpinLock` を利用したスレッドセーフなカウンタ

mutable struct SpinLockCounter
    count::Int
    lock::Threads.SpinLock
    SpinLockCounter() = new(0, Threads.SpinLock())
end

# +
next!(counter::SpinLockCounter) = 
    Base.@lock counter.lock counter.count += 1

counter = SpinLockCounter();
# -

Threads.@threads for n=1:1000
    next!(counter)
end

counter.count

# #### ロック機構による排他制御(2)

# #### コード9-50. スレッドアンセーフの例(2)：再帰を伴う辞書の更新

function update!(d::AbstractDict, n, counter::SpinLockCounter)
    get!(d, n) do
        # println("recursive call $(n)->$(n-1) (threadid: $(Threads.threadid()))")
        update!(d, n-1, counter)
        newcount = next!(counter)
        # println("(n, count): ($n, $newcount) (threadid: $(Threads.threadid()))")
        newcount
    end
end

using Random

ps = randperm(10)

dict = Dict(0 => 0);

counter = SpinLockCounter();

for n in ps
    update!(dict, n, counter)
end

dict

dict = Dict(0 => 0);

counter = SpinLockCounter();

Threads.@threads for n in ps
    update!(dict, n, counter)
end

dict

# #### 仮想コード9-1. コード9-50. のコメントアウトを外して実行

# ```julia
# julia> Threads.@threads for n in ps
#            update!(dict, n, counter)
#        end
# recursive call 5->4 (threadid: 1)
# recursive call 9->8 (threadid: 2)
# recursive call 4->3 (threadid: 1)
# recursive call 2->1 (threadid: 4)
# recursive call 3->2 (threadid: 1)
# recursive call 1->0 (threadid: 4)
# recursive call 2->1 (threadid: 1)
# (n, count): (1, 1) (threadid: 4)
# recursive call 8->7 (threadid: 3)
#   :《中略》
# (n, count): (7, 14) (threadid: 3)
# (n, count): (8, 15) (threadid: 3)
# (n, count): (7, 16) (threadid: 2)
# (n, count): (8, 17) (threadid: 2)
# (n, count): (9, 18) (threadid: 2)
# recursive call 10->9 (threadid: 2)
# (n, count): (10, 19) (threadid: 2)
# ```

# #### コード9-51. スレッドセーフの例(3)：再帰を伴う辞書の更新（`ReentrantLock` 利用）

function update!(d::AbstractDict, n, counter::SpinLockCounter, lck)
    lock(lck) do
        get!(d, n) do
            # println("recursive call $(n)->$(n-1) (threadid: $(Threads.threadid()))")
            update!(d, n-1, counter)
            newcount = next!(counter)
            # println("(n, count): ($n, $newcount) (threadid: $(Threads.threadid()))")
            newcount
        end
    end
end

ps  # 先ほどランダムシャッフルした数列

dict = Dict(0 => 0);

counter = SpinLockCounter();

lck = ReentrantLock()  # `Threads.SpinLock()` ではNG

Threads.@threads for n in ps
    update!(dict, n, counter, lck)
end

dict

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

# ## 9-3. マルチプロセス

# ### 9-3-1. Julia のマルチプロセシング

# #### コード9-52. プロセス数・ワーカープロセスの確認と追加(1)

using Distributed

nprocs()

workers()

addprocs(4)

nprocs()

workers()

# #### コード9-53. プロセス数・ワーカープロセスの確認と追加(2)

# ```julia
# julia> # 起動時に `julia -t 4 -p 4` としていた場合
#
# julia> Threads.nthreads()
# 4
#
# julia> using Distributed
#
# julia> nprocs()
# 5
#
# julia> workers()
# 4-element Vector{Int64}:
#  2
#  3
#  4
#  5
# ```

# ### 9-3-2. マルチプロセスの基本

# #### `@everywhere`

# #### コード9-54. `@everywhere` の使用例

using Distributed

@everywhere using Random

@everywhere function fib(n)
    if n ≤ 1
        n
    else
        fib(n - 2) + fib(n - 1)
    end
end

# #### `remotecall()`

# #### コード9-55. `remotecall` の使用例

workers()

future = remotecall(randperm, 2, 10)

fetch(future)

future = remotecall(n->(myid(), fib(n)), 3, 40);

fetch(future)

# #### コード9-56. `remotecall_fetch` の使用例

workers()

remotecall_fetch(n->(myid(), fib(n)), 3, 40)  # `fetch(remotecall(～))` と同等

# #### `pmap()`

# #### コード9-57. `pmap` の使用例

# `using Distributed`/`addprocs()` 等は実行済とする
workers()

pmap(n->(myid(), fib(n)), 40:-1:21)

# #### コード9-43. `threaded_map()`（マルチスレッド版 `map()`）の実装例（再掲）

# +
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
# -

# #### コード9-58. `map()`/`pmap()`/`threaded_map()` の実行結果比較

# `julia -t 4 -p 4` 等として起動している前提
Threads.nthreads()

last.(map(n->(myid(), fib(n)), 40:-1:21)) ==
last.(pmap(n->(myid(), fib(n)), 40:-1:21)) == 
last.(collect(threaded_map(n->(myid(), fib(n)), 40:-1:21)))

using BenchmarkTools

@btime map(n->(myid(), fib(n)), 40:-1:21);

@btime pmap(n->(myid(), fib(n)), 40:-1:21);

@btime collect(threaded_map(n->(myid(), fib(n)), 40:-1:21));

# #### `RemoteChannel`

# #### コード9-59. `RemoteChannel` の使用例

jobs = RemoteChannel(()->Channel{Int}(8))

results = RemoteChannel(()->Channel{Tuple{Int,Int}}(8))

@everywhere function do_work(jobs, results)
    while true
        n = take!(jobs)
        value = fib(n)
        put!(results, (myid(), value))
    end
end

@async for n=40:-1:21
    put!(jobs, n)
end;

for p in workers()
    remote_do(do_work, p, jobs, results)
end

for _=1:20
    (pid, value) = take!(results)
    println((pid, value))
end

# #### `SharedArray`

# #### コード9-60. `SharedArray` の使用例

@everywhere using SharedArrays

S = SharedArray{Tuple{Int,Int},1}(20)

inputs = RemoteChannel(()->Channel{Int}(8))

@async for n=40:-1:21
    put!(inputs, n)
end;

@sync for p in procs(S)
    @async remotecall_wait(p, p, S, inputs) do p, S, inputs
        for idx in localindices(S)
            n = take!(inputs)
            value = fib(n)
            S[idx] = (p, value)
        end
    end
end

S

# #### `@distributed`

# #### コード9-61. `@distributed` の使用例(1)：単純な `for` ループのマルチプロセス化

@everywhere using SharedArrays

S = SharedArray{Tuple{Int,Int},1}(20);

inputs = RemoteChannel(()->Channel{Int}(8));

@async for n=40:-1:21
    put!(inputs, n)
end;

@sync @distributed for idx = 1:20
    p = myid()
    n = take!(inputs)
    value = fib(n)
    S[idx] = (p, value)
end

S

# #### コード9-62. `@distributed` の使用例(2)：マルチプロセシング＋畳み込み演算

# `using Distributeed` 等略
nprocs()

workers()

function mcpi_st(N=10000)  # シングルプロセス（シングルスレッド）版
    T = sum(1:N) do n
        x = rand()
        y = rand()
        Int(x^2 + y^2 ≤ 1.0)
    end
    T / N * 4
end

mcpi_st()

mcpi_st(100000)

function mcpi_mp(N=10000)  # マルチプロセス版
    T = @distributed (+) for _=1:N
        x = rand()
        y = rand()
        Int(x^2 + y^2 ≤ 1.0)
    end
    T / N * 4
end

mcpi_mp()

mcpi_mp(100000)

using BenchmarkTools

@btime mcpi_st(1_000_000);

@btime mcpi_mp(1_000_000);

# ### コラム. 分散処理

# #### 仮想コード9-a. 分散処理のサンプル

# ```julia
# julia> using Distributed
#
# julia> addprocs(2)
# 2-element Vector{Int64}:
#  2
#  3
#
# julia> addprocs([("username@xxxxxxxx.local", 2)]; 
#        dir="/home/username/Documents", exename="/home/username/bin/julia")
# 2-element Vector{Int64}:
#  4
#  5
#
# julia> addprocs([("username@yyyyyyyy.local", 2)]; 
#        dir="/Users/username/Documents", exename="/opt/homebrew/bin/julia")
# 2-element Vector{Int64}:
#  6
#  7
#
# julia> pmap(n->(myid(), Sys.MACHINE, n), 1:10)
# 10-element Vector{Tuple{Int64, String, Int64}}:
#  (2, "x86_64-w64-mingw32", 1)
#  (3, "x86_64-w64-mingw32", 2)
#  (4, "x86_64-pc-linux-gnu", 3)
#  (5, "x86_64-pc-linux-gnu", 4)
#  (6, "arm64-apple-darwin21.2.0", 5)
#  (7, "arm64-apple-darwin21.2.0", 6)
#  (6, "arm64-apple-darwin21.2.0", 7)
#  (7, "arm64-apple-darwin21.2.0", 8)
#  (7, "arm64-apple-darwin21.2.0", 9)
#  (6, "arm64-apple-darwin21.2.0", 10)
#
# julia> @everywhere function fib(n)
#            if n ≤ 1
#                n
#            else
#                fib(n - 2) + fib(n - 1)
#            end
#        end
#
# julia> pmap(n->(myid(), Sys.MACHINE, fib(n)), 40:-1:21)
# 20-element Vector{Tuple{Int64, String, Int64}}:
#  (4, "x86_64-pc-linux-gnu", 102334155)
#  (6, "arm64-apple-darwin21.2.0", 63245986)
#  (7, "arm64-apple-darwin21.2.0", 39088169)
#  (5, "x86_64-pc-linux-gnu", 24157817)
#  (2, "x86_64-w64-mingw32", 14930352)
#  (3, "x86_64-w64-mingw32", 9227465)
#  (3, "x86_64-w64-mingw32", 5702887)
#  (3, "x86_64-w64-mingw32", 3524578)
#  (2, "x86_64-w64-mingw32", 2178309)
#  (2, "x86_64-w64-mingw32", 1346269)
#  (5, "x86_64-pc-linux-gnu", 832040)
#  (3, "x86_64-w64-mingw32", 514229)
#  (2, "x86_64-w64-mingw32", 317811)
#  (3, "x86_64-w64-mingw32", 196418)
#  (2, "x86_64-w64-mingw32", 121393)
#  (2, "x86_64-w64-mingw32", 75025)
#  (3, "x86_64-w64-mingw32", 46368)
#  (3, "x86_64-w64-mingw32", 28657)
#  (2, "x86_64-w64-mingw32", 17711)
#  (3, "x86_64-w64-mingw32", 10946)
#
# julia> # 本節で紹介したモンテカルロ法による円周率計算
#        function mcpi_mp(N=10000)
#            T = @distributed (+) for _=1:N
#                x = rand()
#                y = rand()
#                Int(x^2 + y^2 ≤ 1.0)
#            end
#            T / N * 4
#        end
# mcpi_mp (generic function with 2 methods)
#
# julia> using BenchmarkTools
#
# julia> @btime mcpi_mp(6_000_000)
#   7.260 ms (426 allocations: 18.78 KiB)
# 3.1428073333333333
# ```

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

# ## 1-1. Julia の特徴

# ### 1-1-1. Julia は高速！

# #### 仮想コード1-1. Julia における `@time` マクロを利用した実行時間計測例

# ```julia
# julia> @time ex1();
#   1.783576 seconds
#
# julia> @time ex2();
#   2.629585 seconds (320.55 k allocations: 16.377 MiB, 66.23% compilation time)
# ```

# ### 1-1-2. Julia は動的！

# ### 1-1-3. Julia は動的型付け！

# #### コード1-1. `typeof()` 関数による具象型の調査

typeof(1)  # 環境によって結果が異なることがあります。

typeof(9.99)

typeof("123ABCあいう漢字")

# #### コード1-2. Julia の型システム概観

Int64 <: Signed <: Integer <: Number  # 型階層

isconcretetype(Int64)  # 具象型であることの確認

isabstracttype(Number)  # 抽象型であることの確認

typeof([1, 2, 3])  # パラメトリック型の例

typeof([1, 2, 3]) <: Vector{<:Integer}  # 型制約

# ### 1-1-4. Julia は多重ディスパッチ！

# ### 1-1-5. 直感的な記述！

# #### コード1-3. 一般的で直感的な記述のコード例

numbers = [1, 2, 3]

function add(x, y)
    x + y
end

# #### コード1-4. 数式に似た直感的な記述のコード例

# $$
# f(x) = x^2 - 2x + 1
# $$

f(x) = x^2 - 2x + 1

# $$
# A = \begin{pmatrix}
# 1 & 2 \\
# 3 & 4
# \end{pmatrix}
# $$

A = [1 2
     3 4]

# #### 仮想コード1-2. 変数（識別子）として有効な Unicode 文字の例

# ```julia
# θ
# Fₙ
# σ²
# μ
# x̄
# ```

# + `\theta` + <kbd>TAB</kbd> （⇒ `θ`）
# + `F\_n` + <kbd>TAB</kbd> （⇒ `Fₙ`）
# + `\sigma` + <kbd>TAB</kbd> + `\^2` + <kbd>TAB</kbd> （⇒ `σ²`）
# + `\mu` + <kbd>TAB</kbd> （⇒ `μ`）
# + `x\bar` + <kbd>TAB</kbd> （⇒ `x̄`）

# #### コード1-5. REPLのhelpモード（`π`という定数の調査）の例

#=
?π
=#

# ### 1-1-6. 真のマクロ！

# #### コード1-6. マクロの定義例

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

# #### 仮想コード1-3. マクロの実行例（`ex1()` という関数を定義しないと動作しません）

# ```julia
# julia> ex1()
# 11
#
# julia> @time_ns ex1()
# elapsed time: 1782868700 nanoseconds
# 11
#
# julia> @time ex1()
#   1.783576 seconds (162.24 k allocations: 8.645 MiB, 61.34% compilation time)
# 11
# ```

# ### 1-1-7. 並行・並列プログラミング！

# #### コード1-7. 処理に時間のかかる関数の例（フィボナッチ数を計算する再帰関数）

function fib(n)
    if n ≤ 1
        n
    else
        fib(n - 2) + fib(n - 1)
    end
end

# #### コード1-8. 処理時間計測例(1)：そのまま実行

@time println(fib(40))

# #### コード1-9. 処理時間計測例(2)：`for` 文で4回実行

@time for _=1:4
    println(fib(40))
end

# #### コード1-10. 処理時間計測例(3)：`for` 文で4回実行（マルチスレッド化）

@time Threads.@threads for _=1:4
    println(fib(40))
end

# ### 1-1-8. 組み込みパッケージマネージャ！

# #### コード1-11. REPLのパッケージモードの例(1)：パッケージの追加・状態確認

# ```julia
# (@v1.7) pkg> add BenchmarkTools Primes StaticArrays
#     Updating registry at `~/.julia/registries/General`
#    Resolving package versions...
#    Installed IntegerMathUtils ─ v0.1.0
#    Installed Primes ─────────── v0.5.2
#    Installed BenchmarkTools ─── v1.3.1
#    Installed StaticArrays ───── v1.4.4
# Updating `~/.julia/environments/v1.7/Project.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#   [27ebfcd6] + Primes v0.5.2
#   [90137ffa] + StaticArrays v1.4.4
# Updating `~/.julia/environments/v1.7/Manifest.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#     : 《一部省略》
#   [8e850b90] + libblastrampoline_jll
# Precompiling project...
#   ✓ IntegerMathUtils
#     : 《一部省略》
#   ✓ StaticArrays
#   7 dependencies successfully precompiled in 4 seconds (15 already precompiled)
#
# (@v1.7) pkg> status
#       Status `~/.julia/environments/v1.7/Project.toml`
#   [6e4b80f9] BenchmarkTools v1.3.1
#   [27ebfcd6] Primes v0.5.2
#   [90137ffa] StaticArrays v1.4.4
#
# ```

#=
]add BenchmarkTools Primes StaticArrays
=#

#=
]st
=#

# + [markdown] tags=[]
# #### コード1-12. REPLのパッケージモードの例(2)：仮想環境作成
# -

# ```julia
# (@v1.7) pkg> activate SampleEnv
#   Activating new environment at `/path/to/currentdir/SampleEnv/Project.toml`
#
# (SampleEnv) pkg> add BenchmarkTools
#     Updating registry at `~/.julia/registries/General`
#    Resolving package versions...
# Updating `/path/to/currentdir/SampleEnv/Project.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
# Updating `/path/to/currentdir/SampleEnv/Manifest.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#     : 《以下省略》
#
# (SampleEnv) pkg> status
# Status `/path/to/currentdir/SampleEnv/Project.toml`
#   [6e4b80f9] BenchmarkTools v1.3.1
#
# ```

#=
]activate SampleEnv
=#

#=
 ]st
=#

# #### 仮想コード1-4. REPLのパッケージモードの例(3)：仮想環境の再現（事前に `Project.toml` ファイルのコピー等の作業が必要）

# ```julia
# (@v1.7) pkg> activate .
#   Activating environment at `/path/to/otherdir/SampleEnv/Project.toml`
#
# (SampleEnv) pkg> instantiate
#     Updating registry at `~/.julia/registries/General`
# Updating `/path/to/otherdir/SampleEnv/Project.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
# Updating `/path/to/otherdir/SampleEnv/Manifest.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#     : 《以下省略》
#
# (SampleEnv) pkg> status
# Status `/path/to/otherdir/SampleEnv/Project.toml`
#   [6e4b80f9] BenchmarkTools v1.3.1
# ```



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

# ## 7-1. ブロードキャスティングとは？

# ### 7-1-1. ドット構文（おさらい）

# #### コード7-1. シグモイド関数（定義）

function sigmoid(x)
    inv(1 + exp(-x))
end

# #### コード7-2. シグモイド関数の動作確認（引数にスカラーを渡した場合）

sigmoid(-8)

sigmoid(-6)

sigmoid(-4)

sigmoid(-2)

sigmoid(0)

sigmoid(2)

sigmoid(4)

sigmoid(6)

sigmoid(8)

sigmoid(Inf)

sigmoid(-Inf)

# #### コード7-3. シグモイド関数の動作確認（内包表記とドット構文によるベクタ化の比較）

[sigmoid(x) for x in -8:2:8]

sigmoid.(-8:2:8)

# #### コード7-4. 代入におけるドット構文の利用

v0 = zeros(5)

r0 = 1:5

v0 .= r0;  # `for i in axes(v0) v0[i] = r0[i] end` と同等の処理

v0

v0 .*= [2^x for x=0:4];
v0

v1 = v0;  # `v1` にはそのまま代入（＝同じ配列を参照）
v2 = similar(v0); v2 .= v0;  # `v2` として同じサイズ・同じ要素型の新しい配列を確保した上でドット構文による代入

v0[1] = -1;

v0

v1  # === `v0`

v2  # != `v0`

# #### コード7-5. シグモイド関数による内包表記とドット構文の動作比較（多次元配列、タプル）

A = [-5.0 0.0; 0.0 5.0];

[sigmoid(x) for x in A]

sigmoid.(A)

t = (-Inf, -1, 0, 1, Inf);

[sigmoid(x) for x in t]

sigmoid.(t)

# ### 7-1-2. ブロードキャスティング

# #### コード7-6. ブロードキャスティングの例(1)（ベクトルとスカラーの計算）

μ = 5.0;  # `μ` は "\mu"+<TAB> で入力できます。
σ = 2.0;  # `σ` は "\sigma"+<TAB> で入力できます。
N = 500;

snds = randn(N);  # 要素数 500 の標準正規分布に則った乱数列（ベクトル）

nds1 = [v * σ + μ for v in snds];  # 方法1：内包表記

nds2 = snds .* fill(σ, N) .+ fill(μ, N);  # 方法2：`fill(○, N)` を利用したドット構文（ベクタ化）

nds3 = snds .* σ .+ μ;  # 方法3：ブロードキャスティング

nds1 == nds2 == nds3

# #### コード7-7. ブロードキャスティングの例(2)（コード7-6. のパフォーマンス比較）

randnds1(N, μ, σ) = [v * σ + μ for v in randn(N)]  # 方法1

randnds2(N, μ, σ) = randn(N) .* fill(σ, N) .+ fill(μ, N)  # 方法2

randnds3(N, μ, σ) = randn(N) .* σ .+ μ  # 方法3

using Random

(Random.seed!(1234);randnds1(N, μ, σ)) == 
(Random.seed!(1234);randnds2(N, μ, σ)) == 
(Random.seed!(1234);randnds3(N, μ, σ))

@time randnds1(10000, μ, σ);

@time randnds2(10000, μ, σ);

@time randnds3(10000, μ, σ);

# #### コード7-8. ブロードキャスティングの例(3)（行列とベクトルとの演算例）

A1 = zeros(3, 3)

v1 = 1:3

A1 + v1

A1 + v1'

A1 .+ v1  # `A1 + [v1 v1 v1]` と同等

A1 .+ v1'  # `A1 + [v1'; v1'; v1']` と同等

# #### コード7-9. ブロードキャスティングの例(4)（サイズと次元拡張）

A2 = [10 30; 20 40]

A3 = reshape(1:6, (2, 1, 3))

size(A2)

size(A3)

size(A2 .+ A3)

A2 .+ A3

(1:9) .* (1:9)'  # `(9,)` と `(1, 9)` との演算で結果は `(9, 9)` （9×9の行列）となる

binomial.(0:5, (0:5)')  # 演算子だけでなく（2引数以上の）関数でもOK

zeros(2, 4) .+ zeros(4, 2)  # 一方が `1` でなければ（例え倍数でも）NG

# ### 7-1-3. `@.` マクロ

# #### コード7-10. `@.` マクロの使用例(1)

a = 0.0:0.5:4.0;

inv.(abs.(sin.(a)))

@. inv(abs(sin(a)))  # equivalent to `inv.(abs.(sin.(a)))` 

@. max(sin(a), cos(a))  # equivalent to `max.(sin.(a), cos.(a))`

@. sin(a * a') + 1  # equivalent to `sin.(a .* a') .+ 1`

# #### コード7-11. `@.` マクロの使用例(2)

A = [1 2; 3 5];
B = [2 3; 4 1];
c = [1, -1];

A * B .+ c

@. A * B + c  # equivalent to `A .* B .+ c` NOT to `A * B .+ c`

@. $(A * B) + c  # equivalent to `A * B .+ c`

μ = 5.0; σ = 2.0; N = 500;

randn(N) .* σ .+ μ  # 実行する度に結果は変わります

@. randn(N) * σ + μ

@. $randn(N) * σ + μ  # 実行する度に結果は変わります

@. $sum(A * B)  # same as `sum(A .* B)`

# ### 7-1-4. ブロードキャスティングの特徴

# #### コード7-12. ブロードキャスティングの例(5)

a = [1.2, ℯ, π, √99];

map(x -> floor(Int, x), a)

[floor(Int, x) for x in a]

floor.(Int, a)

# #### コード7-13. ドット構文（ブロードキャスティング）のNG例(1)

a2 = [1, 2]; a3 = [3, 4, 5];

a2 .* a2 == map(*, a2, a2) == [1, 4]  # 要素数が同じものどうしなら結果は同じ

map(*, a2, a3)  # `map` 関数は `a2` と `a3` の要素数が異なっていても動作する

a2 .* a3

A = [1 2; 3 4];

map(*, A, a3)  # `map` 関数ならこれも動作する

A .* a3

# #### コード7-14. ドット構文（ブロードキャスティング）のNG例(2)

randnds3(N, μ, σ) = randn(N) .* σ .+ μ  # コード7-7. 参照（再掲）

μ = 5.0; σ = 2.0;

xs = randnds3(5000, μ, σ);
ys = randnds3(6000, μ, σ);

extrema(xs .* ys' .+ 1)  # 方法1：ブロードキャスティングを利用

extrema(x * y + 1 for x in xs, y in ys)  # 方法2：ジェネレータ式を利用

chk_extrema1(xs, ys, c) = extrema(xs .* ys' .+ c)

chk_extrema2(xs, ys, c) = extrema(x * y + c for x in xs, y in ys)

chk_extrema1(xs, ys, 1) == chk_extrema2(xs, ys, 1)

@time chk_extrema1(xs, ys, 1);

@time chk_extrema2(xs, ys, 1);

chk_extrema1′(xs, ys, c) = @. $extrema(xs * ys' + c)

chk_extrema1′(xs, ys, 1) == chk_extrema1(xs, ys, 1) == chk_extrema2(xs, ys, 1)

@time chk_extrema1′(xs, ys, 1);

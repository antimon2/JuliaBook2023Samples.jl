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

# ## 12-2. 基本的な道具の使い方

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）  
# ※ `Chapter12-1..jl` を一通り実行済、という前提となります。

#=
]activate stats_wk
=#

# ### 12-2-1. 可視化（データプロット）の基本

# #### コード12-2. `Plots.jl` の使用例(1)：関数のみを指定してプロット

using Plots, StatsPlots  # 環境によっては時間がかかります、以下略

ENV["GKS_ENCODING"] = "utf8";  # ラベル等に日本語を表示する際に必要

gr()  # GR バックエンドを使用することを明示

plot(sin)  # 最初のプロットは時間がかかる場合があります

# #### コード12-3. `plot()` の使用例(2)：関数と定義域を指定してプロット

# +
# `using Plots`～`gr()` 略
# -

xs = range(-2π, 2π, length=100);
plot(sin, xs)

# #### コード12-4. `plot()` の使用例(3)：データ（1次元配列）を指定してプロット

ns = [314, 159, 265, 358, 979, 323, 846, 264, 338, 327];
plot(ns)

# #### コード12-5. `plot()` の使用例(4)：データ（x軸、y軸）を指定してプロット

using Dates

xs = Date(2021,4,1):Month(1):Date(2022,4,1);
ys = rand(13) .* 100;
plot(xs, ys)

# #### コード12-6. `plot()` の使用例(5)：関数2つ（x / y）と媒介変数（値列）を指定してプロット

ts = range(0, 8, length=400);
plot(t->t*sinpi(t), t->t*cospi(t), ts,
    title="代数螺旋",
    fontfamily="sans-serif-roman")

# #### コード12-7. 線種の例

sampledata = cumsum(randn(50, 5), dims=1);  # 50行5列のランダムデータ
plot(sampledata,
    lw = 3,  # ←線の太さ（`linewidth`）
    ls = [:solid :dash :dot :dashdot :dashdotdot],
    legendtitle="線種",  # 凡例のタイトル
    labels=["実線" "破線" "点線" "一点鎖線   " "二点鎖線   "],
    fontfamily="sans-serif-roman"
)

# #### コード12-8. 点種の例（兼、散布図プロット（`scatter()`）の例）

sampledata = cumsum(randn(50, 5), dims=1);  # 50行5列のランダムデータ
scatter(sampledata,  # `plot(～; st=:scatter, ～)` と同じ
    ms = 5,  # 点のサイズ（`markersize`）
    marker = [:circle :rect :diamond :utriangle :star5],
    legendtitle="点種",
    labels=["丸" "四角" "ダイヤ  " "三角" "星"],
    fontfamily="sans-serif-roman"
)

# #### コード12-9. 複数のプロットの重ね合わせ例（ポアソン分布の計測値と理論値）

using SpecialFunctions: gamma

function poissonchoice(λ=4.0, l=100)
    r = λ / l
    sum(rand() < r for _=1:l)
end

poissoncurve(λ) = k -> λ^k * exp(-λ) / gamma(k+1)  # `gamma()` はガンマ関数

λ = 4.0;

# データ無しで `plot()` を呼び出すことで謂わば「キャンバス」を用意
plt = plot(title="ポアソン分布", fontfamily="sans-serif-roman");

# +
pdist = [poissonchoice(λ) for _=1:1000];

# ↓ `plot!(plt, ～; st=:histogram)` と同じ
histogram!(plt, pdist, bins=0:15, norm=true, label="計測値  ");
# -

plot!(plt, poissoncurve(λ), range(0, 15, length=100), lw=3, label="理論値  ")

# ### 12-2-2. データフレームの基本

# #### コード12-10. `DataFrames.jl` の使用例(1)：簡単なデータフレームの作成例

using DataFrames

df_sample = DataFrame(;
    name=["Alice", "Bob", "Carol"],
    age=[19, 24, 35],
    height=[158.0, 172.3, 163.5],
)

describe(df_sample)

# #### コード12-11. `DataFrames.jl` の使用例(2)：行（データ）の追加例

push!(df_sample, ("Dave", 29, 167.0))

data4append = [
    ("Ellen", 20, 129.3),
    ("Frank", 9, 99.9),
]

df4append = DataFrame([r[i] for r=data4append, i=1:ncol(df_sample)], names(df_sample))

# +
# ↑列の型が `Any` となってしまうが追加時に適切に扱われるので問題ない
# -

append!(df_sample, df4append)

describe(df_sample)

# #### コード12-12. `DataFrames.jl` の使用例(3)：列（変数）の追加例

insertcols!(df_sample, :weight=>[missing, 72.6, 58.0, 80.1, 129.3, 99.9])
# `df_sample[!, :weight] = [missing, 72.6, 58.0, 80.1, 129.3, 99.9]` でもOK
# （ただし戻り値は追加したデータ）

describe(df_sample)

# #### コード12-13. `DataFrames.jl` の使用例(4)：インデクシングによるデータの抽出

df_sample[!, :name]

df_sample[!, :name] === df_sample[!, :name]
# 元のデータを参照しているだけなのでオブジェクトとして同一

df_sample[!, :name] == df_sample[:, :name] !== df_sample[!, :name]
# `:` を指定するとコピーを作成

df_sample[!, [:name, :age]]  # `df_sample[:, [:name, :age]]` としてもほぼ同様

row = df_sample[1, :]

row.name

row.age

(row...,)

ntrow = (;row...,);

(ntrow.name, ntrow.age)

# ↓ 要：Julia v1.7 以降
(; name, age) = row; (name, age)

df_sample[1:3, :]

df_sample[df_sample[!, :age] .< 20, :]

df_sample[df_sample[!, :name] .== "Alice", :]

# (df_sample[df_sample[!, :name] .== "Alice", :]...,)  # NG
(only(df_sample[df_sample[!, :name] .== "Alice", :])...,)

df_sample[1, :age]  # 1行目の年齢

# #### コード12-14. `RDatasets.jl` の使用例："iris" データセットのロード

using RDatasets

iris = dataset("datasets", "iris")

describe(iris)

# #### コード12-15. `@df` マクロ（`StatsPlots.jl` で提供）を利用したデータフレームのプロット例

using Plots, StatsPlots

ENV["GKS_ENCODING"] = "utf8";

gr();

plt1 = @df iris scatter(:PetalWidth, :PetalLength);

plt2 = @df iris scatter(:PetalWidth, :PetalLength, group=:Species, marker=[:circle :rect :diamond]);

plot(plt1, plt2, layout=(1, 2), size=(800, 300), legend=:bottomright)

# #### コード12-16. ペアプロットの例（"iris"データセット）

using Plots.PlotMeasures

let iris=iris
    _hist(attr) = @df iris groupedhist(iris[!, attr], group=:Species,
        bins=11, bar_position=:stack, alpha=0.6, legend=nothing)
    _scatter(attr1, attr2) = @df iris scatter(iris[!, attr1], iris[!, attr2], group=:Species,
        m=[:circle :rect :diamond], alpha=0.6, legend=nothing)
    attrs = [:SepalLength, :SepalWidth, :PetalLength, :PetalWidth]
    _plts = [attr1==attr2 ? _hist(attr1) : _scatter(attr1, attr2)
        for attr1 in attrs, attr2 in attrs]
    for x = 1:4
        plot!(_plts[x, 4], xlabel=string(attrs[x]))
    end
    for y = 1:4
        plot!(_plts[1, y], ylabel=string(attrs[y]))
    end
    plot!(_plts[4, 1], legend=:topleft)
    plot(_plts...; layout=(4, 4), size=(1024, 768), leftmargin=10px)
end

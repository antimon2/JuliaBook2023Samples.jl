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

# ## 12-3. 実例：ネット上に公開されているデータの読み込みと簡単な解析

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）  
# ※ `Chapter12-1..ipynb` を一通り実行済、という前提となります。

#=
]activate stats_wk
=#

# ### コード12-17. URL を指定した CSV の読み込み例

using DataFrames, CSV, HTTP

url = "https://covid19.mhlw.go.jp/public/opendata/newly_confirmed_cases_daily.csv";

df = CSV.read(HTTP.request("GET", url).body, DataFrame; dateformat="y/m/d")

# ### コード12-18. 日付の範囲でデータフレームを抽出

using Dates

dts2021d = Date(2021, 4, 1):Day(1):Date(2022, 3, 31)

df2021d = df[df[!, :Date] .∈ Ref(dts2021d), :]

# ### コード12-19. ALL列（全国の数）のプロット(1)：そのままプロット

using Plots, StatsPlots

ENV["GKS_ENCODING"] = "utf8";

gr();

@df df2021d plot(:Date, :ALL, label="日別  ",
    title="全国の新規陽性者数（2021/4/1～2022/3/31）", fontfamily="sans-serif-roman")

# ### コード12-20. ALL列（全国の数）のプロット(2)：スムース化結果重ね合わせ

# +
# `using Plots` ～ `gr()` 略（以下同）
# -

using Loess  # 要：事前に `]add Loess`

# +
plt_all_2021d = @df df2021d plot(:Date, :ALL, ls=:dash, label="日別  ", legend=:topleft,
    title="全国の新規陽性者数（2021/4/1～2022/3/31）", fontfamily="sans-serif-roman");

model = loess(1:nrow(df2021d), df2021d.ALL, span=0.15);

vs = Loess.predict(model, Float64.(1:nrow(df2021d)));

@df df2021d plot!(plt_all_2021d, :Date, vs, w=2, label="スムース化     ")
# -

# ### コード12-21. 相関分析の例：相関係数算出、可視化

using Statistics

@df df2021d cor(:Hokkaido, :Okinawa)

@df df2021d scatter(:Hokkaido, :Okinawa,
    legend=false, xlabel="北海道", ylabel="沖縄", fontfamily="sans-serif-roman")

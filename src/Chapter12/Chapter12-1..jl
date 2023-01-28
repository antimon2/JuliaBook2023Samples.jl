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

# ## 12-1. Juliaでデータ解析

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

# ### コード12-1. 本章の仮想環境（プロジェクト環境）構築

# ```julia
# julia> mkdir("stats_wk") |> cd
#
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> activate .
#   Activating new project at `/path/to/stats_wk`
#
# (stats_wk) pkg> add Plots StatsPlots DataFrames RDatasets CSV HTTP SpecialFunctions Loess Dates
#     Updating registry at `~/.julia/registries/General`
#     Updating git-repo `https://github.com/JuliaRegistries/General`
#    Resolving package versions...
#    # ：《以下略》、環境によっては時間がかかる場合があります
#
#
# (stats_wk) pkg> st
#       Status `/path/to/stats_wk/Project.toml`
#   [336ed68f] CSV v0.10.4
#   [a93c6f00] DataFrames v1.3.3
#   [cd3eb016] HTTP v0.9.17
#   [4345ca2d] Loess v0.5.4
#   [91a5bcdd] Plots v1.27.6
#   [ce6b1742] RDatasets v0.7.7
#   [276daf66] SpecialFunctions v2.1.4
#   [f3b207a7] StatsPlots v0.14.33
#   [ade2ca70] Dates
# ```

# mkdir("stats_wk") |> cd
mkpath("stats_wk") |> cd

#=
]activate .
=#

#=
]add Plots@1.27.6 StatsPlots@0.14.33 DataFrames@1.3.3 RDatasets@0.7.7 CSV@0.10.4 HTTP@0.9.17 SpecialFunctions@2.1.4 Loess@0.5.4 Dates
=#

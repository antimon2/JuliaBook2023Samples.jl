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

# ## 13-1. Juliaで機械学習

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

# ### コード13-1. 単純な線形回帰の例

# ※ 参考: https://github.com/mossr/BeautifulAlgorithms.jl/blob/master/src/linear_regression.jl  
# 　 ↓は↑を少し改変したもの

function linear_regression(X, y)
    𝐗 = [ones(eltype(X), size(y)) X]
    θ = 𝐗'𝐗\𝐗'y
    return x -> [1;x]'θ
end

y = Float32.(1:10);
x1 = rand(Float32, 10) .* (1:10); X = [x1 ((1:10) .- x1)];

f = linear_regression(X, y)

[f([v, v]) for v in 1:10]

[f([v, v]) for v in 1:10] ≈ 2:2:20

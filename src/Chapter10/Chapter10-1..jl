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

# ## 10-1. Julia のパッケージマネージャ

# ### 10-1-1. REPL のパッケージモード

# #### 仮想コード10-1. Julia のパッケージモード

# ※本文中では「仮想コード」だが、Jupyterではパッケージモードのコマンド実行および履歴が残せるので、可能なものはそのまま載せる。以下同様

#=
]?
=#

#=
]? st
=#

# #### 仮想コード10-A2. パッケージの状態確認と追加の例

#=
]status
=#

#=
]add Primes StaticArrays
=#

#=
]st
=#

# ### 10-1-2. `Project.toml`/`Manifest.toml`

# #### リスト10-1. `Project.toml`（一例）

# ```toml
# [deps]
# BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
# Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
# StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
# ```

# #### リスト10-2. `Manifest.toml`（一例、抜粋）

# ```toml
# # This file is machine-generated - editing it directly is not advised
#
# julia_version = "1.7.2"
# manifest_format = "2.0"
#
# [[deps.Artifacts]]
# uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
#
# [[deps.BenchmarkTools]]
# deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
# git-tree-sha1 = "940001114a0147b6e4d10624276d56d531dd9b49"
# uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
# version = "1.2.2"
#
# # :《中略》
#
# [[deps.JSON]]
# deps = ["Dates", "Mmap", "Parsers", "Unicode"]
# git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
# uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
# version = "0.21.2"
#
# # :《中略》
#
# [[deps.Primes]]
# git-tree-sha1 = "984a3ee07d47d401e0b823b7d30546792439070a"
# uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
# version = "0.5.1"
#
# # :《中略》
#
# [[deps.StaticArrays]]
# deps = ["LinearAlgebra", "Random", "Statistics"]
# git-tree-sha1 = "74fb527333e72ada2dd9ef77d98e4991fb185f04"
# uuid = "90137ffa-7385-5640-81b9-e52037218182"
# version = "1.4.1"
#
# [[deps.Statistics]]
# deps = ["LinearAlgebra", "SparseArrays"]
# uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
#
# # :《以下略》
# ```

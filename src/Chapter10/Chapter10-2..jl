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

# ## 10-2. 基本的な使い方

# ### パッケージの追加・更新・削除

# #### 仮想コード10-3. パッケージモードのコマンド実行例（パッケージ登録関連）

#=
]st
=#

#=
]st -m
=#

#=
]add Example
=#

#=
]st
=#

#=
]rm Example
=#

#=
]st
=#

#=
]up BenchmarkTools
=#

#=
]st -m
=#

# #### 仮想コード10-4. `add` コマンドの他の例（実行結果例省略）

# ```julia
# (@v1.7) pkg> add Example@0.5.0
#
# (@v1.7) pkg> add Example#master
#
# (@v1.7) pkg> add Example=7876af07-990d-54b4-ab0e-23690620f79a
#
# (@v1.7) pkg> add https://github.com/JuliaLang/Example.jl.git
# ```

# ### パッケージの固定・固定解除、開発モード・開発モード解除

# #### 仮想コード10-5. パッケージモードのコマンド実行例（パッケージ固定・開発・解除）

#=
]add Example@0.5.0
=#

#=
]st Example
=#

#=
]pin Example
=#

#=
]up Example
=#

#=
]st Example
=#

#=
]free Example
=#

#=
]up Example
=#

#=
]st Example
=#

#=
]dev Example
=#

#=
]st Example
=#

#=
]free Example
=#

#=
]st Example
=#

# ### その他のパッケージ関連コマンド

# ### パッケージレジストリ関連コマンド

# #### 仮想コード10-6. パッケージモードのコマンド実行例（パッケージレジストリ関連）

#=
]registry st
=#

#=
]registry up
=#

# ```julia
# (@v1.7) pkg> registry add https://github.com/githubuser/MyPkgRegistry
# # 《出力例省略》
#
# (@v1.7) pkg> registry rm MyPkgRegistry
# # 《出力例省略》
# ```

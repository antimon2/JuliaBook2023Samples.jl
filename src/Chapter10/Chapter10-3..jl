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

# ## 10-3. 環境の管理

# ### 10-3-1. 環境（仮想環境）

# #### 仮想コード10-7. 仮想環境の作成例

pwd()

mkdir("testenv");
cd("testenv");

#=
]activate .
=#

#=
]st
=#

# #### 仮想コード10-8. 仮想環境へのパッケージ追加例

#=
]add Example@0.5.0
=#

#=
]st
=#

# #### 仮想コード10-9. 仮想環境とデフォルト環境

#=
]activate
=#

#=
]st
=#

#=
]activate .
=#

#=
]st
=#

#=
]st -m
=#

# #### 仮想コード10-10. 一時的な仮想環境

#=
]activate --temp
=#

#=
]add Example@0.5.0
=#

#=
]st
=#

# ### 10-3-2. プロジェクト

# #### 仮想コード10-11. プロジェクト環境のインスタンス化（`instantiate`）

cd("..");
mkdir("anotherdir");
cd("anotherdir");

pwd()

print(read("../testenv/Project.toml", String))

mkdir("tmpenv2");
cp("../testenv/Project.toml", "tmpenv2/Project.toml")

#=
]activate tmpenv2
=#

#=
]st
=#

#=
]instantiate
=#

#=
]st
=#

# #### リスト10-3. `Project.toml` 編集例（`[compat]` セクション追記）

# ```toml
# [deps]
# Example = "7876af07-990d-54b4-ab0e-23690620f79a"
#
# [compat]
# Example = "= 0.5.0"
# ```

# #### 仮想コード10-12. プロジェクト環境のインスタンス化（`instantiate`）その2

mkdir("tmpenv3");
cp("tmpenv2/Project.toml", "tmpenv3/Project.toml");

open("tmpenv3/Project.toml", "a") do f
    print(f, """

[compat]
Example = "= 0.5.0"
""")
end

#=
]activate tmpenv3
=#

#=
]st
=#

#=
]instantiate
=#

#=
]st
=#

# #### 仮想コード10-13. julia 起動時のコマンドライン引数で特定の環境を活性化する例

# ```shell
# $ julia --project=tmpenv2  # tmpenv2環境（tmpenv2ディレクトリ）を活性化
#
# $ julia --project  # `--project=@.` と同じ
#
# $ julia --project main.jl  # カレントディレクトリを活性化し `main.jl` を直接実行する例
# ```

# ### 10-3-3. パッケージディレクトリ

# #### 仮想コード10-14. パッケージ `HelloWorld` 作成例

cd(mkpath("../newpkgwk"))

#=
]generate HelloWorld
=#

#=
]activate HelloWorld
=#

#=
]st
=#

print(read("HelloWorld/Project.toml", String))  # 自動生成される

print(read("HelloWorld/src/HelloWorld.jl", String))  # 自動生成される

#=
]activate .
=#

#=
]add HelloWorld
=#

#=
]dev ./HelloWorld
=#

#=
]st
=#

print(read("./Project.toml", String))

using HelloWorld

HelloWorld.greet()

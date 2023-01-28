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

# ## 13-2. MLJ.jl

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

# ### コード13-2. `MLJ.jl` 実験用の仮想環境（プロジェクト環境）構築

# ```julia
# julia> mkdir("mlj_wk") |> cd
#
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> activate .
#   Activating new project at `/path/to/mlj_wk`
#
# (mlj_wk) pkg> add MLJ DataFrames
#     Updating registry at `~/.julia/registries/General`
#     Updating git-repo `https://github.com/JuliaRegistries/General`
#    Resolving package versions...
#    # ：《以下略》、環境によっては時間がかかる場合があります
#
# (mlj_wk) pkg> st
#       Status `/path/to/mlj_wk/Project.toml`
#   [a93c6f00] DataFrames v1.3.4
#   [add582a8] MLJ v0.18.2
# ```

# mkdir("mlj_wk") |> cd
mkpath("mlj_wk") |> cd

#=
]activate .
=#

#=
]add MLJ DataFrames
=#

#=
]st
=#

# ### コード13-3. `MLJ.jl` の使用例(1)："iris" データセットのロードと確認

using MLJ

iris = load_iris()

typeof(iris)

selectrows(iris, 1:3) |> pretty

using DataFrames

selectrows(DataFrame(iris), 1:3)

# ### コード13-4. `MLJ.jl` の使用例(2)：目的変数と説明変数の展開

y, X = unpack(iris, ==(:target); shuffle=true)

selectrows(X, 1:3) |> pretty

# ### コード13-5. `MLJ.jl` の使用例(3)：説明変数と目的変数の組にマッチするモデルの検索

models(matching(X, y))

models(matching(X, y)) |> last

# ### コード13-6. `MLJ.jl` の使用例(4)：モデル（分類器）のロード、構築

XGBoost = @load XGBoostClassifier add=true

model = XGBoost();

mach = machine(model, X, y)

# ### コード13-7. `MLJ.jl` の使用例(5)：学習

train_rows, test_rows = partition(eachindex(y), 0.7);

fit!(mach, rows=train_rows)

# ### コード13-8. `MLJ.jl` の使用例(6)：推測、評価（エントロピー、正解率）

ŷ = predict(mach, selectrows(X, test_rows))

log_loss(ŷ, y[test_rows]) |> mean

mode.(ŷ)

# accuracy(ŷ, y[test_rows])  # ←NG
accuracy(mode.(ŷ), y[test_rows])

# ### コード13-9. `MLJ.jl` の使用例(7)：評価（混同行列、マクロ平均F値）

# cfm = confusion_matrix(mode.(ŷ), y[test_rows])  # ←警告が出る
cfm = confusion_matrix(mode.(ŷ), coerce(y[test_rows], OrderedFactor))

cfm.mat

fscoreM(ŷ::AbstractVector{<:UnivariateFinite}, y) = fscoreM(mode.(ŷ), y)

function fscoreM(ŷ, y)
    cfm = confusion_matrix(ŷ, coerce(y, OrderedFactor))
    axis = axes(cfm.mat, 1)
    tmp = [
        (;
            tp=cfm.mat[i, i],
            fp=sum(cfm.mat[i, axis.!=i]),
            fn=sum(cfm.mat[axis.!=i, i]),
            # tn=sum(cfm.mat[axis.!=i, axis.!=i])
        )
        for i in axis
    ]
    preM = mean(tp==fp==0 ? 0.0 : tp/float(tp+fp) for (;tp, fp) in tmp)
    recM = mean(tp==fn==0 ? 0.0 : tp/float(tp+fn) for (;tp, fn) in tmp)
    preM == recM == 0.0 ? 0.0 : 2 * preM * recM / (preM + recM)
end

fscoreM(mode.(ŷ), y[test_rows])  # `fscoreM(ŷ, y[test_rows])` でもOK

# ### コード13-10. `MLJ.jl` の使用例(8)：外部データの推測例

new_data = (sepal_length=5.0, sepal_width=3.0, petal_length=5.0, petal_width=2.0)

predict(mach, DataFrame(;new_data...))

predict_mode(mach, DataFrame(;new_data...))

# ### コード13-11. `MLJ.jl` の使用例(9)：`evaluate()` 関数

evaluate(model, X, y; measure=[log_loss, accuracy, fscoreM])

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

# ## 13-3. Flux.jl

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

# ### コード13-12. `Flux.jl` 実験用の仮想環境（プロジェクト環境）構築

# ```julia
# julia> mkdir("flux_wk") |> cd
#
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> activate .
#   Activating new project at `/path/to/flux_wk`
#
# (flux_wk) pkg> add Flux MLDatasets MLJBase ImageCore Statistics
#     Updating registry at `~/.julia/registries/General`
#     Updating git-repo `https://github.com/JuliaRegistries/General`
#    Resolving package versions...
#    # ：《以下略》、環境によっては時間がかかる場合があります
#
# (flux_wk) pkg> st
#       Status `/path/to/flux_wk/Project.toml`
#   [587475ba] Flux v0.13.0
#   [a09fc81d] ImageCore v0.9.3
#   [eb30cadb] MLDatasets v0.5.16
#   [a7f614a8] MLJBase v0.20.2
#   [10745b16] Statistics
# ```

# mkdir("flux_wk") |> cd
mkpath("flux_wk") |> cd

#=
]activate .
=#

#=
]add Flux@0.13.0 MLDatasets@0.5.16 MLJBase@0.20.2 ImageCore@0.9.3 Statistics
=#

#=
]st
=#

# ### コード13-13. `Flux.jl` 使用例(1)：前準備

# +
using Flux

using Flux: onehotbatch, onecold, throttle, @epochs

using Flux.Data: DataLoader

using MLDatasets.MNIST, Statistics

using MLJBase: accuracy
# -

# ### コード13-14. `Flux.jl` 使用例(2)：ネットワーク（モデル）構築

model = Chain(
    Conv((5, 5), 1=>32, relu),
    MaxPool((2, 2)),
    Conv((5, 5), 32=>64, relu),
    MaxPool((2, 2)),
    Flux.flatten,
    Dense(1024, 1024, relu),
    Dropout(0.5),
    Dense(1024, 10),
    # softmax
) |> gpu

# ### コード13-15. `Flux.jl` 使用例(3)：`loss` 関数の定義例

struct Loss{M} <: Function
    model::M
end

(loss::Loss)(x, y) = Flux.logitcrossentropy(loss.model(x), y)

(loss::Loss)((;data, label)) = loss(data, label)  # 要：Julia v1.7 以降

# ### コード13-16. `Flux.jl` 使用例(4)：MNISTデータセットのロードと `DataLoader` の使用例

function loadMNIST(::Type{T}, batchsize::Int = 1000) where {T<:AbstractFloat}
    train_x = reshape(MNIST.traintensor(T), 28, 28, 1, :) |> gpu
    train_y = onehotbatch(MNIST.trainlabels(), 0:9) |> gpu
    test_x = reshape(MNIST.testtensor(T), 28, 28, 1, :) |> gpu
    test_y = onehotbatch(MNIST.testlabels(), 0:9) |> gpu

    train_data = DataLoader((data=train_x, label=train_y), batchsize=batchsize, shuffle=true)
    (train_data, test_x, test_y)
end

batchsize = 1000;
traindata, tX, tY = loadMNIST(Float32, batchsize)

# ### コード13-17. `Flux.jl` 使用例(5)：MNISTデータの内容確認セットのロードと `DataLoader` の使用例

nt = first(traindata) |> cpu;

using ImageCore

for i=1:3
    println("label: ", onecold(nt.label[:, i], 0:9))
    display(MNIST.convert2image(nt.data[:, :, 1, i]))
end

# ### コード13-18. `Flux.jl` 使用例(6)：ロードしたデータと `model()`/`loss()`/`accuracy()` の動作確認

size(first(traindata).data)

model(first(traindata).data[:, :, :, 1:10])

model(tX)

Loss(model)(tX, tY)

accuracy(onecold(model(tX)), onecold(tY))

@info("metrics",accuracy=accuracy(onecold(model(tX)), onecold(tY)))

# ### コード13-19. `Flux.jl` 使用例(7)：`train!()` 関数の整備とコールバックの準備

function train!(m, traindata; epochs = 10, cb = identity)
    loss = Loss(m)
    _params = Flux.params(m)
    opt = ADAM()
    @epochs epochs Flux.train!(loss, _params, traindata, opt; cb=cb)
end

evalcb = throttle(() -> @info("metrics", accuracy=accuracy(onecold(model(tX)), onecold(tY))), 10)

# ### コード13-20. `Flux.jl` 使用例(8)：`train!()` の実行例

# train!(model, traindata; epochs=100, cb=evalcb)
# GPUが使えるなら↑こちらでもOK
train!(model, traindata; epochs=10, cb=evalcb)

# ### コード13-21. `Flux.jl` 使用例(9)：学習結果の確認・推測

Loss(model)(tX, tY)

ŷ = model(tX) |> cpu |> onecold;

y = tY |> cpu |> onecold;

accuracy(ŷ, y)

new_data = rand(Float32, 784);  # 実際には何らかの 28×28 のデータ

reshape(new_data, 28, 28, 1, 1) |> gpu |> model |> cpu |> (y->onecold(y, 0:9)) |> only

# ### コード13-22. `Flux.jl` 使用例(10)：混同行列・マクロ平均F値

using MLJBase: coerce, confusion_matrix, OrderedFactor

confusion_matrix(ŷ, coerce(y, OrderedFactor))  # 混同行列

# ↓前節のものと同じもの（再掲）
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

fscoreM(ŷ, y)

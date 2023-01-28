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

# ## 7-2. ブロードキャスティングの実装

# ### 7-2-1. ドット構文も構文糖衣

# #### コード7-15. ドット構文と等価な関数呼び出し例(1)

sin.([0.0, 1.0, π/2])

broadcast(sin, [0.0, 1.0, π/2])

(1:9) .+ (1:9)'

broadcast(+, (1:9), (1:9)')

# #### コード7-16. ドット構文と等価な関数呼び出し例(2)

A = Matrix{Float32}(undef, 3, 3);

A .= sqrt.([1, 4, 9]);
A

A .+= [.1 .2 .3];
A

broadcast!(sqrt, A, [1, 4, 9]);
A

broadcast!(+, A, A, [.1 .2 .3]);
A

# ### 7-2-2. ブロードキャスティングの仕組み

# #### 仮想コード7-1. broadcast()/broadcast!() 関数と等価なコード

# ```julia
# # equivalent to `broadcast(fn, xs...)`
# Broadcast.materialize(Broadcast.broadcasted(f, xs...))
#
# # equivalent to `broadcast!(fn, dest, xs...)`
# Broadcast.materialize!(dest, Broadcast.broadcasted(f, xs...))
# ```

# #### コード7-17. ドット構文とデシュガーされたコード例(1)

sin.([0.0, 1.0, π/2])

Broadcast.materialize(Broadcast.broadcasted(sin, [0.0, 1.0, π/2]))

(1:9) .+ (1:9)'

Broadcast.materialize(Broadcast.broadcasted(+, (1:9), (1:9)'))

# #### コード7-18. ドット構文とデシュガーされたコード例(2)

A = Matrix{Float32}(undef, 3, 3);

A .= sqrt.([1, 4, 9]);
A

A .+= [.1 .2 .3];
A

Broadcast.materialize!(A, Broadcast.broadcasted(sqrt, [1, 4, 9]));
A

Broadcast.materialize!(A, Broadcast.broadcasted(+, A, [.1 .2 .3]));
A

# #### `Broadcast.broadcasted()` と `Broadcast.materialize()`

# ##### コード7-19. Broadcast.broadcastable() の動作例

Broadcast.broadcastable([1, 2, 3])  # そのまま返す

Broadcast.broadcastable([1. 2.; 3. 4.])  # そのまま返す

Broadcast.broadcastable(('a', :ok, π))  # そのまま返す

Broadcast.broadcastable(1)

Broadcast.broadcastable("string")

Broadcast.broadcastable(Int)

Broadcast.broadcastable(Set([1, 2, 3]))  # collect(Set([1, 2, 3])) と一致

Broadcast.broadcastable(Dict(:a=>1, :b=>2))

Broadcast.broadcastable((a=1, b="B"))

struct MySingleton end
Broadcast.broadcastable(MySingleton())

# ##### コード7-20. ブロードキャスティングの例(6)

A = [1 1; 1 0];

A .^ (0:10)

Ref(A) .^ (0:10)

replace_with_dict(str::AbstractString, dict::AbstractDict) = 
    replace(str, ∈(keys(dict))=>c->dict[c])

dict0 = Dict('o'=>'0', 'i'=>'1', 'z'=>'2', 'e'=>'3',
    'a'=>'4', 's'=>'5', 'b'=>'6', 't'=>'7');

replace_with_dict("Julia", dict0)

strs = ["Julia", "Python", "Ruby", "Haskell"];

replace_with_dict.(strs, Ref(dict0))

replace_with_dict.(strs, dict0)

# #### `Broadcast.BroadcastStyle`

# ##### コード7-21. `Broadcast.BroadcastStyle` の確認(1)

Broadcast.broadcastable([1, 2, 3]) |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable(Float32[1 2; 3 4]) |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable(1:10) |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable((1, 2.0, 3//1)) |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable(1) |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable("string") |> typeof |> Broadcast.BroadcastStyle

Broadcast.broadcastable(Ref([1 1; 1 0])) |> typeof |> Broadcast.BroadcastStyle

# ##### コード7-22. `Broadcast.BroadcastStyle` の確認(2)

bs0 = Broadcast.BroadcastStyle(Int)

bs1 = Broadcast.BroadcastStyle(Vector{Int})

bs2 = Broadcast.BroadcastStyle(Matrix{Int})

bst = Broadcast.BroadcastStyle(typeof((1, 2, 3)))

Broadcast.BroadcastStyle(bs0, bs1)

Broadcast.BroadcastStyle(bs0, bs2)

Broadcast.BroadcastStyle(bs1, bs2)

Broadcast.BroadcastStyle(bs0, bst)

Broadcast.BroadcastStyle(bs1, bst)

Broadcast.BroadcastStyle(bs2, bst)

Broadcast.BroadcastStyle(bs1, bs0)

Broadcast.BroadcastStyle(bst, bs0)

all(Broadcast.BroadcastStyle(bs, bs) === bs for bs in (bs0, bs1, bs2, bst))

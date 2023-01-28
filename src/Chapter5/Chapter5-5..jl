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

# ## 5-5. 糖衣構文

# ### 5-5-1. 糖衣構文（の多く）も多重ディスパッチ

# ### 5-5-2. 例

# #### 例1. インデクシング関連

# ##### コード5-28.	GeometricSequence.jl（コード5-20.、コード5-24. 再掲）

# +
struct GeometricSequence{T<:Number} <: AbstractVector{T}
    a::T
    r::T
    n::Int
end

function GeometricSequence(a::T1, r::T2, n::Integer) where {T1<:Number, T2<:Number}
    GeometricSequence(promote(a, r)..., Int(n))
end

Base.length(seq::GeometricSequence) = seq.n
Base.size(seq::GeometricSequence) = (seq.n,)
Base.getindex(seq::GeometricSequence, index::Integer) = seq.a * seq.r ^ (index - 1)

function Base.show(io::IO, seq::GeometricSequence)
    print(io, "GeometricSequence(", seq.a, ", ", seq.r, ", ", seq.n, ")")
end
Base.show(io::IO, ::MIME"text/plain", seq::GeometricSequence) = show(io, seq)

function Base.sum(seq::GeometricSequence)
    seq.a * (1 - seq.r^seq.n) / (1 - seq.r)
end

function Base.sum(seq::GeometricSequence{<:Rational})
    c = numerator(seq.a)
    b = denominator(seq.a)
    q = numerator(seq.r)
    p = denominator(seq.r)
    n = seq.n
    c * (p^n - q^n) // (b * p^(n-1) * (p - q))
end

function Base.sum(seq::GeometricSequence{<:Integer})
    seq.a * ((seq.r^seq.n - 1) ÷ (seq.r - 1))
end
# -

# ##### コード5-29.	`GeometricSequence` におけるインデクシングの動作例

seq1 = GeometricSequence(1, 0.5, 20);

seq1[1] == getindex(seq1, 1) == 1.0

seq1[2] == getindex(seq1, 2) == 0.5

seq1[10]

seq1[20]

seq1[2:4]

seq1[begin]

seq1[end]

# ##### コード5-30.	FreeIndexList.jl

# +
mutable struct FreeIndexList{N<:Number}
    _begin::Int
    _end::Int
    data::Dict{Int, N}

    FreeIndexList{N}() where {N} = new{N}(1, 0, Dict{Int, N}())
    function FreeIndexList(src::AbstractVector{N}) where {N}
        _begin = firstindex(src)
        _end = lastindex(src)
        d = Dict(i=>src[i] for i in _begin:_end)
        new{N}(_begin, _end, d)
    end
end

# getindex()
Base.getindex(fil::FreeIndexList{N}, i) where N = get(fil.data, i, zero(N))
Base.getindex(fil::FreeIndexList, idxs::AbstractVector) = [fil[i] for i in idxs]

# setindex!()
function Base.setindex!(fil::FreeIndexList, v, i)
    if fil._begin > fil._end
        fil._begin = fil._end = i
    else
        fil._begin > i && (fil._begin = i)
        fil._end < i && (fil._end = i)
    end
    fil.data[i] = v
end

# `begin`
Base.firstindex(fil::FreeIndexList) = fil._begin

# `end`
Base.lastindex(fil::FreeIndexList) = fil._end
# -

# ##### コード5-31.	`FreeIndexList` のインデクシング動作例

fil = FreeIndexList([1, 1, 2, 3, 5])

fil[1]  # == getindex(fil, 1)

fil[2:6]  # == getindex(fil, 2:6)

for i = 6:10
    fil[i] = fil[i-1] + fil[i-2]
end

fil

fil[end]

for i = -1:-1:-10
    fil[i] = fil[i+2] - fil[i+1]
end

fil[-10] == fil[begin] == -55

fil[begin:end]  # == fil[-10:10]

# #### 例2. プロパティ

# ##### コード5-32.	プロパティ参照の定義・実行例 (1)

struct PropParrot end

Base.getproperty(::PropParrot, name::Symbol) = name

parrot = PropParrot()

parrot.a

parrot.do

parrot.some_long_name

parrot.日本語もOK

parrot.var"こうすれば スペース区切でも OK!"

# ##### コード5-33.	プロパティ参照の定義・実行例 (2)

struct PropParrot2{X, Y}
    x::X
    y::Y
end

function Base.getproperty(parrot2::PropParrot2, name::Symbol)
    hasfield(PropParrot2, name) && return getfield(parrot2, name)
    name
end

parrot2 = PropParrot2(123, "漢字")

parrot2.x

parrot2.y

parrot2.z

parrot2.var"x,y,z"

# ##### コード5-34.	Future.jl

# +
mutable struct Future
    value
    done::Bool

    function Future()
        object = new()
        # object.done = false
        setfield!(object, :done, false)
        object
    end
    function Future(value)
        new(value, true)
    end
end

function Base.getproperty(f::Future, name::Symbol)
    name === :value || return getfield(f, name)
    f.done || error("the field `value` has not been setteled yet")
    getfield(f, :value)  # `f.value` と書いては絶対ダメ
end

function Base.setproperty!(f::Future, name::Symbol, value)
    name === :done && error("the field `done` cannot be changed manually")
    name === :value || return setfield!(f, name, value)  # この場合はなくても良い
    f.done && error("`value` has already been set.")
    setfield!(f, :done, true)  # `f.done = true` と書いてはいけない
    setfield!(f, :value, value)  # `f.value = value` と書いては絶対ダメ
end
# -

# ##### コード5-35.	`Future` の動作例

f1 = Future()

f1.done

f1.value

f1.value = "A String"

f1.done

f1.value

f2 = Future(π)

f2.done

f2.value

f2.value = "Other Value"

f2.done = false

# #### 例3. 後置演算子 `'～`

# ##### コード5-36.	後置演算子 `'` の多重定義例

let _trtable = Dict(
    'い'=>'こ','こ'=>'い','く'=>'へ','へ'=>'く','し'=>'つ','つ'=>'し','も'=>'や','や'=>'も',
    'キ'=>'サ','サ'=>'キ','シ'=>'ツ','ツ'=>'シ','セ'=>'ヤ','ヤ'=>'セ','ソ'=>'ン','ン'=>'ソ',
    'フ'=>'レ','レ'=>'フ','マ'=>'ム','ム'=>'マ','ラ'=>'ル','ル'=>'ラ'
)
    Base.var"'"(c::AbstractChar) = get(_trtable, c, c)
    # ↓のように書いても同じ
    # Base.adjoint(c::AbstractChar) = get(_trtable, c, c)
end

'A''

'い''

['や', 'も', 'つ', 'ル', 'ー', 'メ', 'ソ']'

# ##### コード5-37.	後置演算子 `'～` の定義例

const var"'⁺" = transpose  # `'⁺` は `'\^+` + TAB で変換可能

A = [1 2; 3 4]

A'

A'⁺

var"'²"(x) = x^2  # `'²` は `'\^2` + TAB で変換可能

A'²

A'²'²'²  # == ((A^2)^2)^2

var"'₂"(x) = string(x, base=2)  # `'₂` は `'\_2` + TAB で変換可能

10'₂

123'₂

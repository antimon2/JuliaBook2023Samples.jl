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

function Base.iterate(seq::GeometricSequence)
    seq.n > 0 || return nothing
    (seq.a, (seq.a * seq.r, seq.n - 1))
end
function Base.iterate(seq::GeometricSequence, (next, count)::NTuple{2})
    count == 0 && return nothing
    (next, (next * seq.r, count - 1))
end
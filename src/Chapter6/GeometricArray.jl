struct GeometricArray{T<:Number, N} <: AbstractArray{T, N}
    a::T
    r::T
    ns::NTuple{N, Int}
end

function GeometricArray(a::T1, r::T2, ns::NTuple{N, Integer}) where {T1, T2, N}
    GeometricArray(promote(a, r)..., Int.(ns))
end

function Base.show(io::IO, box::GeometricArray)
    print(io, "GeometricArray(", box.a, ", ", box.r, ", ", box.ns, ")")
end
Base.show(io::IO, ::MIME"text/plain", box::GeometricArray) = show(io, box)

# Base.IteratorSize(GeometricArray{Int, 3}) == Base.HasShape{3}()

Base.size(box::GeometricArray) = box.ns
# `Base.length()` はデフォルト実装を利用

# Base.IteratorEltype(GeometricArray) == Base.HasEltype()
# eltype(GeometricArray{Int, 3}) == Int

Base.IndexStyle(::Type{<:GeometricArray}) = IndexLinear()
@inline function Base.getindex(box::GeometricArray, idx::Int) where {T, N}
    @boundscheck checkbounds(box, idx::Int)
    box.a * box.r ^ (idx - 1)
end
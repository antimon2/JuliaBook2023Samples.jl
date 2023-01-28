struct GeometricBox{T<:Number, N}
    a::T
    r::T
    ns::NTuple{N, Int}
end

function GeometricBox(a::T1, r::T2, ns::NTuple{N, Integer}) where {T1, T2, N}
    GeometricBox(promote(a, r)..., Int.(ns))
end

#### `IteratorSize()`
Base.IteratorSize(::Type{GeometricBox{T, N}}) where {T, N} = Base.HasShape{N}()
Base.size(box::GeometricBox) = box.ns
Base.length(box::GeometricBox) = prod(box.ns)

#### `IteratorEltype()`
# Base.IteratorEltype(::Type{<:GeometricBox}) = Base.HasEltype()
Base.eltype(::Type{<:GeometricBox{T}}) where {T} = T

#### `iterate()`
Base.iterate(box::GeometricBox) = (box.a, (box.a, length(box) - 1))
function Base.iterate(box::GeometricBox{T}, (prev, rest)::Tuple{T, Int}) where {T}
    rest == 0 && return nothing
    next = prev * box.r
    (next, (next, rest - 1))
end
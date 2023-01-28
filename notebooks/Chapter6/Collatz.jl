struct Collatz{I <: Integer}
    start::I
end

Base.IteratorSize(::Type{<:Collatz}) = Base.SizeUnknown()

Base.IteratorEltype(::Type{<:Collatz}) = Base.HasEltype()
Base.eltype(::Type{Collatz{I}}) where I = I

Base.iterate(c::Collatz) = (c.start, c.start)
function Base.iterate(::Collatz, prev)
    prev == 1 && return nothing
    next = if iseven(prev)
        prev ÷ 2
    else
        3prev + 1
    end
    (next, next)
end
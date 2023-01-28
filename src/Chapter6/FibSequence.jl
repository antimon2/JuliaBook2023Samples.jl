struct FibSequence end
const Fib = FibSequence()

Base.IteratorSize(::Type{FibSequence}) = Base.IsInfinite()

# Base.IteratorEltype(::Type{FibSequence}) = Base.HasEltype()
Base.eltype(::Type{FibSequence}) = BigInt

Base.iterate(::FibSequence) = iterate(Fib, (big"1", big"0"))

function Base.iterate(::FibSequence, (Fₙ₋₂, Fₙ₋₁)::NTuple{2, BigInt})
    Fₙ = Fₙ₋₂ + Fₙ₋₁
    (Fₙ, (Fₙ₋₁, Fₙ))
end
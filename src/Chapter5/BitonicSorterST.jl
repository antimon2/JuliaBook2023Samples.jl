module BitonicSorterST

# ref: https://en.wikipedia.org/wiki/Bitonic_sorter

export BitonicSort

using Base.Order: Ordering, lt

struct BitonicSortAlg <: Base.Sort.Algorithm end
const BitonicSort = BitonicSortAlg()

function Base.sort!(x::AbstractVector, lo::Integer, hi::Integer, ::BitonicSortAlg, o::Ordering)
    lo ≥ hi && return x

    fullsize::Int = hi - lo
    d = sizeof(Int) * 8 - leading_zeros(fullsize - 1)  # == ceil(Int, log(2, fullsize))

    for p = 1:d, q = 1:p
        _sort_kernel!(x, lo, hi, p, q, o)
    end
    return x
end

function _sort_kernel!(x::AbstractVector, lo, hi, p, q, o)
    # @assert p ≥ q
    halfsize_1 = Int(hi - lo) >> 0x01
    d = 1 << UInt(p - q)
    for s = 0:halfsize_1
        ioff = s & (d - 1)
        seg = lo + (s ⊻ ioff) << 0x01
        joff = q == 1 ? (2d - ioff - 1) : ioff + d
        i = seg + ioff
        j = seg + joff
        if !lt(o, x[i], x[j])
            x[i], x[j] = x[j], x[i]
        end
    end
end

end # module
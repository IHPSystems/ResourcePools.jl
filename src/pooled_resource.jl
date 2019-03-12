abstract type AbstractPooledResource{T} end

mutable struct PooledResource{T} <: AbstractPooledResource{T}
    resource::T
    ref_count::Int
    dispose::Function
    function PooledResource(r::T, dispose::Function) where T
        new{T}(r, 1, dispose)
    end
end

resource(r) = r.resource
ref_count(r) = r.ref_count

function release!(r)
    if r.ref_count < 1
        throw(ArgumentError("Cannot release a resource with ref_count zero!"))
    end
    @debug "Releasing $(r)"
    r.ref_count -= 1
    if r.ref_count == 0
        @debug "Disposing $(r)"
        r.dispose(r)
    end
end

function retain!(r)
    if r.ref_count < 1
        throw(ArgumentError("Cannot retain a resource with ref_count zero!"))
    end
    @debug "Retaining $(r)"
    r.ref_count += 1
end

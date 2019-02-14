abstract type AbstractPooledResource{T} end

mutable struct PooledResource{T} <: AbstractPooledResource{T}
    resource::T
    ref_count::Int
    dispose::Function
    function PooledResource(r::T, dispose::Function) where T
        new{T}(r, 1, dispose)
    end
end

resource(r::AbstractPooledResource) = r.resource
ref_count(r::AbstractPooledResource) = r.ref_count

function release(r::AbstractPooledResource)
    if r.ref_count < 1
        throw(ArgumentError("Cannot release a resource with ref_count zero!"))
    end
    r.ref_count -= 1
    if r.ref_count == 0
        r.dispose(r)
    end
end

function retain(r::AbstractPooledResource)
    r.ref_count += 1
end

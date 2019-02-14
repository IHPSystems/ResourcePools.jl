abstract type AbstractPooledResource{T} end

mutable struct PooledResource{T} <: AbstractPooledResource{T}
    resource::T
    ref_count::Int
    function PooledResource(r::T) where T
        new{T}(r, 1)
    end
end

resource(r::AbstractPooledResource) = r.resource
ref_count(r::AbstractPooledResource) = r.ref_count

function release(r::AbstractPooledResource)
    r.ref_count -= 1
end

function retain(r::AbstractPooledResource)
    r.ref_count += 1
end

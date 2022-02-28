abstract type AbstractResourcePool{T} end

struct ResourcePool{T} <: AbstractResourcePool{T}
    pool::Queue{T}
end

function ResourcePool{T}(resources::AbstractVector{T}) where T
    pool = Queue{T}()
    for resource in resources
        enqueue!(pool, resource)
    end
    return ResourcePool(pool)
end

function ResourcePool{T}(size::Int, create_resource::Function) where T
    pool = Queue{T}()
    for i = 1:size
        enqueue!(pool, create_resource())
    end
    return ResourcePool(pool)
end

Base.length(p::AbstractResourcePool) = length(p.pool)

function Base.take!(p::AbstractResourcePool{T}) where T
    if length(p) < 1
        throw(ArgumentError("$p is empty!"))
    end
    function dispose(r)
        @debug "Returning $(resource(r)) to $(p)"
        enqueue!(p.pool, resource(r))
    end
    r = dequeue!(p.pool)
    if T <: DenseArray
        PooledArray(r, dispose)
    elseif T <: AbstractArray
        PooledAbstractArray(r, dispose)
    else
        PooledResource(r, dispose)
    end
end

abstract type AbstractResourcePool{T} end

struct ResourcePool{T} <: AbstractResourcePool{T}
    pool::Queue{T}
    lock::ReentrantLock
end

function ResourcePool{T}(resources::AbstractVector{T}) where T
    pool = Queue{T}()
    for resource in resources
        enqueue!(pool, resource)
    end
    return ResourcePool(pool, ReentrantLock())
end

function ResourcePool{T}(size::Int, create_resource::Function) where T
    pool = Queue{T}()
    for i = 1:size
        enqueue!(pool, create_resource())
    end
    return ResourcePool(pool, ReentrantLock())
end

Base.length(p::AbstractResourcePool) = length(p.pool)

function Base.take!(p::AbstractResourcePool{T}) where T
    function dispose(r)
        @debug "Returning $(resource(r)) to $(p)"
        lock(p.lock) do
            enqueue!(p.pool, resource(r))
        end
    end
    lock(p.lock) do
        if length(p) < 1
            throw(ArgumentError("$p is empty!"))
        end
        r = dequeue!(p.pool)
        if T <: DenseArray
            return PooledArray(r, dispose)
        elseif T <: AbstractArray
            return PooledAbstractArray(r, dispose)
        else
            return PooledResource(r, dispose)
        end
    end
end

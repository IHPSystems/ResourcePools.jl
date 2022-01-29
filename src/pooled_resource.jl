abstract type AbstractPooledResource{T} end

mutable struct PooledResource{T} <: AbstractPooledResource{T}
    resource::T
    ref_count::Ref{Int}
    lock::ReentrantLock
    dispose::Function
    function PooledResource(r::T, dispose::Function) where T
        new{T}(r, Ref(1), ReentrantLock(), dispose)
    end
end

resource(r) = r.resource
ref_count(r) = r.ref_count[]
ref_count_ref(r) = r.ref_count
ref_count_lock(r) = r.lock
dispose!(r) = r.dispose(r)

function release!(r)
    lock(ref_count_lock(r))
    try
        if ref_count(r) < 1
            throw(ArgumentError("Cannot release a resource with ref_count zero!"))
        end
        @debug "Releasing $(r)"
        ref_count_ref(r)[] -= 1
        if ref_count(r) == 0
            @debug "Disposing $(r)"
            dispose!(r)
        end
    finally
        unlock(ref_count_lock(r))
    end
    return r
end

function retain!(r)
    lock(ref_count_lock(r))
    try
        if ref_count(r) < 1
            throw(ArgumentError("Cannot retain a resource with ref_count zero!"))
        end
        @debug "Retaining $(r)"
        ref_count_ref(r)[] += 1
    finally
        unlock(ref_count_lock(r))
    end
    return r
end

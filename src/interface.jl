mutable struct ReferenceCountingCore
    ref_count::Ref{Int}
    lock::ReentrantLock
    dispose::Function
    ReferenceCountingCore(dispose::Function) = new(Ref(1), ReentrantLock(), dispose)
end

ref_count(c::ReferenceCountingCore) = c.ref_count[]
ref_count_ref(c::ReferenceCountingCore) = c.ref_count
ref_count_lock(c::ReferenceCountingCore) = c.lock
dispose(c::ReferenceCountingCore) = c.dispose

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

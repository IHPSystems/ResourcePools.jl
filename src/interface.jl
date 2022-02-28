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

"""
Release the resource `r` - i.e. decrement the reference count for `r` and dispose it if count reaches zero.
"""
function release!(r)
    lock(ref_count_lock(r)) do
        if ref_count(r) < 1
            throw(ArgumentError("Cannot release a resource with ref_count zero!"))
        end
        @debug "Releasing $(r)"
        ref_count_ref(r)[] -= 1
        if ref_count(r) == 0
            @debug "Disposing $(r)"
            dispose!(r)
        end
    end
    return r
end

"""
Retain the resource `r` - i.e. increment the reference count for `r`.
"""
function retain!(r)
    lock(ref_count_lock(r)) do
        if ref_count(r) < 1
            throw(ArgumentError("Cannot retain a resource with ref_count zero!"))
        end
        @debug "Retaining $(r)"
        ref_count_ref(r)[] += 1
    end
    return r
end

abstract type AbstractPooledResource{T} end

struct PooledResource{T} <: AbstractPooledResource{T}
    resource::T
    ref_count_core::ReferenceCountingCore
    function PooledResource(r::T, dispose::Function) where T
        new{T}(r, ReferenceCountingCore(dispose))
    end
end

resource(r::PooledResource) = r.resource

# ReferenceCounting interface
ref_count(r::PooledResource) = ref_count(r.ref_count_core)
ref_count_ref(r::PooledResource) = ref_count_ref(r.ref_count_core)
ref_count_lock(r::PooledResource) = ref_count_lock(r.ref_count_core)

# Disposable interface
dispose!(r::PooledResource) = dispose(r.ref_count_core)(r)

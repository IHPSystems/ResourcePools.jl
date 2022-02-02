abstract type AbstractPooledArray{T,N} <: AbstractArray{T,N}
end

struct PooledAbstractArray{T,N} <: AbstractPooledArray{T,N}
    array::AbstractArray{T,N}
    ref_count_core::ReferenceCountingCore
    function PooledAbstractArray(a::AbstractArray{T,N}, dispose::Function) where {T,N}
        new{T,N}(a, ReferenceCountingCore(dispose))
    end
end

resource(a::AbstractPooledArray{T,N}) where {T,N} = a.array

# Array interface
Base.size(a::AbstractPooledArray{T,N}) where {T,N} = size(a.array)

Base.IndexStyle(::Type{<:AbstractPooledArray{T,N}}) where {T,N} = IndexCartesian()

Base.getindex(a::AbstractPooledArray{T,N}, indices::Vararg{Int, N}) where {T,N} = a.array[indices...]

Base.setindex!(a::AbstractPooledArray{T,N}, v, indices::Vararg{Int, N}) where {T,N} = a.array[indices...] = v

# ReferenceCounting interface
ref_count(r::PooledAbstractArray) = ref_count(r.ref_count_core)
ref_count_ref(r::PooledAbstractArray) = ref_count_ref(r.ref_count_core)
ref_count_lock(r::PooledAbstractArray) = ref_count_lock(r.ref_count_core)

# Disposable interface
dispose!(r::PooledAbstractArray) = dispose(r.ref_count_core)(r)

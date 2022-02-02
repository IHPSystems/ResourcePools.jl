abstract type AbstractPooledDenseArray{T,N} <: DenseArray{T,N}
end

struct PooledArray{T,N} <: AbstractPooledDenseArray{T,N}
    array::Array{T,N}
    ref_count_core::ReferenceCountingCore
    function PooledArray(a::Array{T,N}, dispose::Function) where {T,N}
        new{T,N}(a, ReferenceCountingCore(dispose))
    end
end

resource(a::AbstractPooledDenseArray{T,N}) where {T,N} = a.array

# Array interface
Base.size(a::AbstractPooledDenseArray{T,N}) where {T,N} = size(a.array)

Base.IndexStyle(::Type{<:AbstractPooledDenseArray{T,N}}) where {T,N} = IndexLinear()

Base.getindex(a::AbstractPooledDenseArray{T,N}, i::Int) where {T,N} = a.array[i]

Base.setindex!(a::AbstractPooledDenseArray{T,N}, v, i::Int) where {T,N} = a.array[i] = v

# ReferenceCounting interface
ref_count(r::PooledArray) = ref_count(r.ref_count_core)
ref_count_ref(r::PooledArray) = ref_count_ref(r.ref_count_core)
ref_count_lock(r::PooledArray) = ref_count_lock(r.ref_count_core)

# Disposable interface
dispose!(r::PooledArray) = dispose(r.ref_count_core)(r)

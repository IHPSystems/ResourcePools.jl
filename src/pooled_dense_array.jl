abstract type AbstractPooledDenseArray{T,N} <: DenseArray{T,N}
end

mutable struct PooledArray{T,N} <: AbstractPooledDenseArray{T,N}
    array::Array{T,N}
    ref_count::Int
    lock::ReentrantLock
    dispose::Function
    function PooledArray(a::Array{T,N}, dispose::Function) where {T,N}
        new{T,N}(a, 1, ReentrantLock(), dispose)
    end
end

resource(a::AbstractPooledDenseArray{T,N}) where {T,N} = a.array

Base.size(a::AbstractPooledDenseArray{T,N}) where {T,N} = size(a.array)

Base.IndexStyle(::Type{<:AbstractPooledDenseArray{T,N}}) where {T,N} = IndexLinear()

Base.getindex(a::AbstractPooledDenseArray{T,N}, i::Int) where {T,N} = a.array[i]

Base.setindex!(a::AbstractPooledDenseArray{T,N}, v, i::Int) where {T,N} = a.array[i] = v

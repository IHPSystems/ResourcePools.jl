abstract type AbstractPooledArray{T,N} <: AbstractArray{T,N}
end

mutable struct PooledAbstractArray{T,N} <: AbstractPooledArray{T,N}
    array::AbstractArray{T,N}
    ref_count::Threads.Atomic{Int}
    dispose::Function
    function PooledAbstractArray(a::AbstractArray{T,N}, dispose::Function) where {T,N}
        new{T,N}(a, Threads.Atomic{Int}(1), dispose)
    end
end

resource(a::AbstractPooledArray{T,N}) where {T,N} = a.array

Base.size(a::AbstractPooledArray{T,N}) where {T,N} = size(a.array)

Base.IndexStyle(::Type{<:AbstractPooledArray{T,N}}) where {T,N} = IndexCartesian()

Base.getindex(a::AbstractPooledArray{T,N}, indices::Vararg{Int, N}) where {T,N} = a.array[indices...]

Base.setindex!(a::AbstractPooledArray{T,N}, v, indices::Vararg{Int, N}) where {T,N} = a.array[indices...] = v

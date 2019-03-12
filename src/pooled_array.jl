mutable struct PooledArray{T,N} <: AbstractArray{T,N}
    array::AbstractArray{T,N}
    ref_count::Int
    dispose::Function
    function PooledArray(a::AbstractArray{T,N}, dispose::Function) where {T,N}
        new{T,N}(a, 1, dispose)
    end
end

resource(a::PooledArray{T,N}) where {T,N} = a.array

Base.size(a::PooledArray{T,N}) where {T,N} = size(a.array)

Base.IndexStyle(::Type{<:PooledArray{T,N}}) where {T,N} = IndexCartesian()

Base.getindex(a::PooledArray{T,N}, indices::Vararg{Int, N}) where {T,N} = a.array[indices...]

Base.setindex!(a::PooledArray{T,N}, v, indices::Vararg{Int, N}) where {T,N} = a.array[indices...] = v

Base.showarg(io::IO, a::PooledArray{T,N}, toplevel) where {T,N} = print(io, typeof(a), " with ref_count $(ref_count(a))")

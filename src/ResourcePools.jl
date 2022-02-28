module ResourcePools

using DataStructures

export AbstractPooledResource,
    PooledResource,
    ref_count,
    resource,
    release!,
    retain!

export AbstractResourcePool,
    ResourcePool,
    length,
    take!

export AbstractPooledArray,
    AbstractPooledDenseArray,
    PooledAbstractArray,
    PooledArray

include("interface.jl")
include("pooled_resource.jl")
include("resource_pool.jl")
include("pooled_abstract_array.jl")
include("pooled_dense_array.jl")

end # module

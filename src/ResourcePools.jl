module ResourcePools

export AbstractPooledResource,
    PooledResource,
    ref_count,
    resource,
    release!,
    retain!

import Base: length, take!
export AbstractResourcePool,
    ResourcePool,
    length,
    take!

export AbstractPooledArray,
    AbstractPooledDenseArray,
    PooledAbstractArray,
    PooledArray

include("pooled_resource.jl")
include("resource_pool.jl")
include("pooled_abstract_array.jl")
include("pooled_dense_array.jl")

end # module

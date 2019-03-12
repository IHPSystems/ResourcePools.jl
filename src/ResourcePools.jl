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

export PooledArray

include("pooled_resource.jl")
include("resource_pool.jl")
include("pooled_array.jl")

end # module

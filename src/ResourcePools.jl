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

include("pooled_resource.jl")
include("resource_pool.jl")

end # module

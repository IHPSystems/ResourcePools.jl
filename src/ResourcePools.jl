module ResourcePools

export AbstractPooledResource,
    PooledResource,
    ref_count,
    resource,
    release!,
    retain!

include("pooled_resource.jl")

end # module

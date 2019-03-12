using Test
@testset "ResourcePools" begin
    include("pooled_resource.jl")
    include("resource_pool.jl")
    include("pooled_array.jl")
end

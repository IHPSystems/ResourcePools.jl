using Test
@testset "ResourcePools" begin
    include("pooled_resource.jl")
    include("resource_pool.jl")
    include("pooled_abstract_array.jl")
    include("pooled_dense_array.jl")
end

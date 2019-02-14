using Test
using ResourcePools

@testset "PooledResource" begin
    a = zeros(10, 10)

    r = PooledResource(a)
    @test ref_count(r) == 1
    @test resource(r) === a

    retain(r)
    @test ref_count(r) == 2

    release(r)
    @test ref_count(r) == 1

    release(r)
    @test ref_count(r) == 0
end

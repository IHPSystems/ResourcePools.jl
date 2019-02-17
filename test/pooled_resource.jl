using Test
using ResourcePools

@testset "PooledResource" begin
    a = zeros(10, 10)

    was_disposed = false
    r = PooledResource(a, (r) -> was_disposed = true)
    @test ref_count(r) == 1
    @test resource(r) === a

    retain!(r)
    @test ref_count(r) == 2

    release!(r)
    @test ref_count(r) == 1

    @test !was_disposed
    release!(r)
    @test ref_count(r) == 0
    @test was_disposed

    @test_throws ArgumentError release!(r)
end

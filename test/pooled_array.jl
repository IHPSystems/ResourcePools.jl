using Test
using ResourcePools

@testset "PooledArray" begin
    a = [1 2; 3 4]

    is_disposed = false
    r = PooledArray(a, (r) -> is_disposed = true)
    @test ref_count(r) == 1
    @test resource(r) === a
    @test r == a

    retain!(r)
    @test ref_count(r) == 2

    release!(r)
    @test ref_count(r) == 1

    @assert !is_disposed "is_disposed is true"
    release!(r)
    @test ref_count(r) == 0
    @test is_disposed

    @test_throws ArgumentError release!(r)
    @test_throws ArgumentError retain!(r)
end

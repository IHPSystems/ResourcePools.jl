using Test
using ResourcePools

@testset "ResourcePool" begin
    p = ResourcePool{Int}(3, () -> 42)
    @test length(p) == 3

    r = take!(p)
    @test length(p) == 2
    @test ref_count(r) == 1

    release!(r)
    @test ref_count(r) == 0
    @test length(p) == 3

    r1, r2, r3 = take!(p), take!(p), take!(p)
    @test length(p) == 0
    @test_throws ArgumentError take!(p)

    release!(r1)
    @test length(p) == 1
    r = take!(p)
end

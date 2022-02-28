using Test
using ResourcePools

@testset "ResourcePool" begin
    @testset "PooledResource" begin
        p = ResourcePool{Int}(3, () -> 42)
        @test length(p) == 3

        r = take!(p)
        @test typeof(r) <: AbstractPooledResource
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

    @testset "PooledArray" begin
        p = ResourcePool{Array{Int,2}}(3, () -> [1 2; 3 4])
        @test length(p) == 3

        a = take!(p)
        @test typeof(a) <: AbstractPooledDenseArray
        @test length(p) == 2
        @test ref_count(a) == 1
        @test sum(a) == 10

        release!(a)
        @test ref_count(a) == 0
        @test length(p) == 3
    end

    @static if VERSION >= v"1.3"
        @testset "Multi-threading" begin
            N = 1000
            p = ResourcePool{Int}(collect(1:N))
            T = Threads.nthreads()
            O = 4 # Over-subscription factor

            M = O * N / T

            function consumer()
                for i in 1:M
                    v = take!(p)
                    release!(v)
                end
            end

            @sync for t in 1:T
                Threads.@spawn consumer()
            end
        end
    end
end

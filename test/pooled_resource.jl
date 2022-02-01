using Test
using ResourcePools

@testset "PooledResource" begin
    a = zeros(2, 2)

    is_disposed = false
    r = PooledResource(a, (r) -> is_disposed = true)
    @test ref_count(r) == 1
    @test resource(r) === a

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

    @static if VERSION >= v"1.3"
        @testset "Multi-threading" begin
            function create()
                a = zeros(2, 2)
                is_disposed = false
                r = PooledResource(a, (r) -> is_disposed = true)
            end

            N = 100

            T = Threads.nthreads()

            channels = [Channel(10) for t = 1:T]

            function producer()
                for i = 1:N
                    v = create()
                    for t = 1:T
                        put!(channels[t], retain!(v))
                    end
                    release!(v)
                end
            end

            function consumer(c)
                for i = 1:N
                    v = take!(c)
                    release!(v)
                end
            end

            @sync begin
                Threads.@spawn producer()
                for t = 1:T
                    Threads.@spawn consumer(channels[t])
                end
            end
        end
    end
end

# ResourcePools

[![Build Status](https://github.com/IHPSystems/ResourcePools.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/IHPSystems/ResourcePools.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/IHPSystems/ResourcePools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/IHPSystems/ResourcePools.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

ResourcePools is a Julia package that enables re-use of "expensive" resources, such as memory allocations, or database connections, by providing functionality for creating and managing pools of such resources. The management of resources is based on reference counting.

ResourcePools provides generic types `ResourcePool{T}`, and `PooledResource{T}`, as well as an array-specific type, `PooledArray{T,N}`.

ResourcePools is thread-safe.

## Usage

```julia
using ResourcePools

# Create a pool of 3 Int resources using a generator method for creating resources
p = ResourcePool{Int}(3, () -> 42)

# Get a resource from the pool
r = take!(p)

# Use the resource

# Return the resource to the pool
release!(p)
```

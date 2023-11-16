const MAX_WEIGHT = 20.0
const MATRÍCULA = "2020041973"

function read_weights(file::IOStream, size::Int64)::Vector{Float64}
    weights::Vector{Float64} = zeros(size)
    for line in eachline(file)
        data = split(line, "\t")
        weights[parse(Int64, data[2])+1] = parse(Float64, data[3])
    end
    return weights
end

function main()
    if length(ARGS) == 0
        return
    end

    input_file::IOStream = open(ARGS[1], "r")
    num_objects::Int64 = parse(Int64, split(readline(input_file), "\t")[2])
    weights::Vector{Float64} = read_weights(input_file, num_objects)

    capacities::Vector{Float64} = fill(MAX_WEIGHT, size(weights))

    sort!(weights, rev=true)

    for w in weights
        for (i, c) in enumerate(capacities)
            if c - w >= 0
                capacities[i] = c - w
                break
            end
        end
    end

    num_bins::Int64 = 0

    for c in capacities
        if c != MAX_WEIGHT
            num_bins += 1
        end
    end

    println("TP2 $MATRÍCULA = $num_bins")

end

main()

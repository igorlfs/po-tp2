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
    bins_content::Vector{Vector{Int64}} = Vector{Vector{Int64}}(undef, 0)

    sort!(weights, rev=true)

    for (i, w) in enumerate(weights)
        added_to_existing_bin = false
        for (j, c) in enumerate(capacities)
            if c - w >= 0
                capacities[j] = c - w

                if isempty(bins_content) || length(bins_content) < j
                    push!(bins_content, [i])
                else
                    push!(bins_content[j], i)
                end

                added_to_existing_bin = true

                break
            end
        end
        if !added_to_existing_bin
            push!(bins_content, [i])
        end
    end

    num_bins::Int64 = length(bins_content)

    println("TP2 $MATRÍCULA = $num_bins")

    for (_, bin_content) in enumerate(bins_content)
        for b in bin_content
            print("$b\t")
        end
        println()
    end

end

main()

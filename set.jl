const MATRÍCULA = "2020041973"

function read_matrix(file::IOStream, size::Int64)::Matrix{Bool}
    adj_matrix::Matrix{Bool} = zeros(Bool, size, size)
    for line in eachline(file)
        data = split(line, "\t")
        a = parse(Int64, data[2])
        b = parse(Int64, data[3])
        adj_matrix[a, b] = true
        adj_matrix[b, a] = true
    end
    return adj_matrix
end

function main()
    if length(ARGS) == 0
        return
    end

    input_file::IOStream = open(ARGS[1], "r")
    num_vertices::Int64 = parse(Int64, split(readline(input_file), "\t")[2])
    adj_matrix::Matrix{Bool} = read_matrix(input_file, num_vertices)

    independent_set = Vector{Int}()

    # Os vértices que já estão cobertos mas não fazem parte do conjunto independente
    covered_vertices = Vector{Int}()

    # Conte os vizinhos
    neighbors_sum = [sum(adj_matrix[x, :]) for x in 1:num_vertices]

    # Coloque vértices isolados dentro do conjunto
    for (i, sum) in enumerate(neighbors_sum)
        if sum == 0
            append!(independent_set, i)
        end
    end

    while true
        min_neighbors_idx = 1
        min_neighbors = typemax(Int64)
        for i in 1:num_vertices
            if neighbors_sum[i] < min_neighbors && !(i in independent_set) && !(i in covered_vertices)
                min_neighbors = neighbors_sum[i]
                min_neighbors_idx = i
            end
        end
        if min_neighbors == typemax(Int64)
            break
        end

        append!(independent_set, min_neighbors_idx)

        # Removendo os vizinhos de min_neighbors_idx
        for (i, v) in enumerate(adj_matrix[min_neighbors_idx, :])
            if v
                append!(covered_vertices, i)
                adj_matrix[:, i] .= 0
                adj_matrix[i, :] .= 0
            end
        end
        # Removendo min_neighbors_idx
        adj_matrix[:, min_neighbors_idx] .= 0
        adj_matrix[min_neighbors_idx, :] .= 0

        neighbors_sum = [sum(adj_matrix[x, :]) for x in 1:num_vertices]
    end

    size_set::Int64 = length(independent_set)

    println("TP2 $MATRÍCULA = $size_set")

    sort!(independent_set)

    for v in independent_set
        print("$v\t")
    end
    println()
end

main()

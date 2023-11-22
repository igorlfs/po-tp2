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

    # Conte os vizinhos, mas como queremos pegar vértices que tem pelo menos um vizinho,
    # coloque a soma de quem tiver 0 vizinhos como infinito
    neighbors_sum::Array{Int64} = [sum(adj_matrix[x, :]) for x in 1:num_vertices]
    neighbors_sum = [x == 0 ? typemax(Int64) : x for x in neighbors_sum]

    independent_set = Set{Int}()

    while !all(x -> x == typemax(Int64), neighbors_sum)
        vertex::Int64 = argmin(neighbors_sum)

        push!(independent_set, vertex)

        neighbors_sum[vertex] = typemax(Int64) # Desconsidere o vértice nas próximas iterações

        for (i, v) in enumerate(adj_matrix[vertex, :])
            if v == 1
                neighbors_sum[i] = typemax(Int64) # Desconsidere também seus vizinhos
            end
        end
    end

    size_set::Int64 = length(independent_set)

    println("TP2 $MATRÍCULA = $size_set")

    for v in independent_set
        print("$v\t")
    end
    println()
end

main()

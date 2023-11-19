const MATRÍCULA = "2020041973"

function read_matrix(file::IOStream, size::Int64)::Matrix{Float64}
    adj_matrix::Matrix{Float64} = zeros(size, size)
    for line in eachline(file)
        data = split(line, "\t")
        a = parse(Int64, data[2])
        b = parse(Int64, data[3])
        c = parse(Float64, data[4])
        adj_matrix[a, b] = c
        adj_matrix[b, a] = c
    end
    return adj_matrix
end

function main()
    if length(ARGS) == 0
        return
    end

    input_file::IOStream = open(ARGS[1], "r")
    num_vertices::Int64 = parse(Int64, split(readline(input_file), "\t")[2])
    adj_matrix::Matrix{Float64} = read_matrix(input_file, num_vertices)

    vertices_weights = zeros(num_vertices)
    for i in 1:num_vertices
        vertices_weights[i] = sum([adj_matrix[i, j] for j in 1:num_vertices])
    end

    removed = fill(false, num_vertices)
    for (i, v) in enumerate(vertices_weights)
        if v < 0 && !removed[i]
            removed[i] = true
            for j in 1:num_vertices
                vertices_weights[j] -= adj_matrix[i, j]
            end
            adj_matrix[i, :] .= 0
            adj_matrix[:, i] .= 0
        end
    end

    cost = 0
    for (i, v) in enumerate(removed)
        if !v
            cost += sum(adj_matrix[i, :])
        end
    end

    println("TP2 $MATRÍCULA = $(cost/2)")
end

main()

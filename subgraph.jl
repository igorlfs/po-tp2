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

    vertices_weights = []
    for i in 1:num_vertices
        push!(vertices_weights, [sum([adj_matrix[i, j] for j in 1:num_vertices]), i])
    end

    removed = fill(false, num_vertices)
    while true
        start = count(removed)

        for i in 1:num_vertices
            vertices_weights[i] = [sum([adj_matrix[i, j] for j in 1:num_vertices]), i]
        end

        sort!(vertices_weights)

        for (vw, i) in vertices_weights
            i = floor(Int, i)
            if vw < 0
                removed[i] = true
                vertices_weights[i] = 0
                for j in 1:num_vertices
                    adj_matrix[j, i] = 0
                    adj_matrix[i, j] = 0
                end
                break
            end
        end

        finish = count(removed)

        if finish == start
            break
        end
    end

    cost = sum(i[1] for i in vertices_weights) / 2

    println("TP2 $MATRÍCULA = $cost")

    sort!(vertices_weights, by=x -> x[2])

    for (_, v) in enumerate(vertices_weights)
        if v[1] > 0
            print("$(floor(Int,v[2]))\t")
        end
    end
    println()
end

main()

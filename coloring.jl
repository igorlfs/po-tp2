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

    degrees = [sum(adj_matrix[i, :]) for i in 1:num_vertices]
    sorted_vertices = sortperm(degrees, rev=true)

    color_assignment = zeros(Int64, num_vertices)

    for v in sorted_vertices
        available = fill(true, num_vertices)
        for i in 1:num_vertices
            if adj_matrix[v, i] && color_assignment[i] != 0
                available[color_assignment[i]] = false
            end
        end
        color = argmax(available)
        color_assignment[v] = color
    end

    num_colors = maximum(color_assignment)

    print("TP2 $MATRÍCULA = $num_colors")
end

main()
